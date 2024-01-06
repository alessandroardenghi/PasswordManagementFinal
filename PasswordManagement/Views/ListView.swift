import Foundation
import SwiftUI
import SwiftData

struct ListView: View {
    
    @State private var new_item = false
    @Environment(\.modelContext) var context
    @StateObject var viewModel = ListViewViewModel()
    @Query private var items: [LoginInfoItem]
    @StateObject var Keychain = KeychainManager()
    @State var search: String = ""
    @State var first_time_tutorial: Bool = false
    @State var tutorial: Bool = false
    @State var secure_variables: [KIandLIT] = []
    @StateObject var Notification = NotificationManager()
    
    var body: some View {
        
        NavigationView {
            List {
                ForEach(secure_variables.indices, id:\.self) {index in
                    NavigationLink(destination: DetailView(variable: $secure_variables[index].item, secure_variable: $secure_variables[index].secure_variable, old_password: secure_variables[index].secure_variable.password, old_subscription_date: secure_variables[index].item.subscription_date, old_subscription_choice: secure_variables[index].secure_variable.subscription)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text("\(secure_variables[index].secure_variable.website)")
                                    .font(.headline)
                                
                                Text("\(secure_variables[index].secure_variable.username)")
                                    .font(.subheadline)
                                
                            }
                            Spacer()
                            
                            // ICON TO REMIND TO CHANGE THE PASSWORD
                            
                            let calendar = Calendar.current
                            let date = calendar.startOfDay(for: secure_variables[index].item.password_modification_date)
                            let today = calendar.startOfDay(for: Date())
                            if let time_passed = calendar.dateComponents([.day], from: date, to: today).day, time_passed >= 90 {
                                Image(systemName: "exclamationmark.triangle")
                                    .foregroundColor(.red)
                            }
                            
                            // ICON TO SHOW BOOKMARKED ITEMS
                            
                            Image(systemName: secure_variables[index].item.bookmark ? "bookmark.fill" : "bookmark")
                                .foregroundColor(.blue)
                        }
                        .swipeActions {
                            Button(role: .destructive) {
                                
                                // DELETING ALL DATA RELATIVE TO THE VARIABLE
                                context.delete(secure_variables[index].item)
                                
                                Keychain.delete(id: secure_variables[index].item.id)
                                
                                Notification.remove_notification(withIdentifier: secure_variables[index].item.id + "password")
                                
                                Notification.remove_notification(withIdentifier: secure_variables[index].item.id + "account")
                                
                                if secure_variables[index].secure_variable.subscription {
                                    Notification.remove_notification(withIdentifier: secure_variables[index].item.id + "subscription")
                                }
                                Notification.see_pending_notifications()
                            } label: {
                                Label("Delete", systemImage: "trash.fill")
                            }
                        }
                        .swipeActions {
                            Button() {
                                secure_variables[index].item.bookmark.toggle()
                            } label: {
                                Label("Bookmark", systemImage: "bookmark.fill")
                            }
                            .tint(.blue)
                        }
                    }
                }
                
            }
            .navigationTitle("Login Info")
            .searchable(text: $search)
            .toolbar {
                Button {
                    if UserDefaults.standard.value(forKey: "TUTORIAL") == nil {
                        first_time_tutorial = true
                    }
                    else {
                        let permission = UserDefaults.standard.bool(forKey: "Notifications")
                        if !permission {
                            Notification.ask_permission()
                        }
                        viewModel.new_item = true
                    }
                }
            label: {
                Image(systemName: "plus")
            }
            .sheet(isPresented: $first_time_tutorial) {
                TutorialView(tutorial_not_seen: $first_time_tutorial)
            }
            .sheet(isPresented: $viewModel.new_item) {
                NewItemView(new_item_inserted: $viewModel.new_item)
            }
                
                
            }
            .toolbar {
                Button {
                    tutorial = true
                }
            label: {
                Image(systemName: "questionmark.circle")
                }
            .sheet(isPresented: $tutorial) {
                TutorialView(tutorial_not_seen: $tutorial)
                }
            }
        }
        .onAppear {
            getItemsFromKeychain(items: searchable_items)
        }
        .onChange(of: searchable_items) { 
            getItemsFromKeychain(items: searchable_items)
        }
        
    }
        
    var sorted_items: [LoginInfoItem] {
        let trueConditionItems = items.filter { $0.bookmark }
        let falseConditionItems = items.filter { !$0.bookmark }
        return trueConditionItems + falseConditionItems
    }
        
    var searchable_items: [LoginInfoItem] {
        if search.isEmpty {
            return sorted_items
        } else {
            return sorted_items.filter { Keychain.get(id: $0.id)!.website.lowercased().contains(search.lowercased()) }
        }
    }
    
    class KIandLIT: Identifiable {
        @Attribute(.unique) var id: String
        var secure_variable: KeychainItem
        var item: LoginInfoItem
        
        init(secure_variable: KeychainItem, item: LoginInfoItem) {
            
            self.id = UUID().uuidString
            self.secure_variable = secure_variable
            self.item = item
        }
    }

    func getItemsFromKeychain(items: [LoginInfoItem]){
        secure_variables = []
        for item in items {
            if let keychainItem = Keychain.get(id: item.id) {
                secure_variables.append(KIandLIT(secure_variable: keychainItem, item: item))
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return ListView()
            .modelContainer(container)
}
