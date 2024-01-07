import Foundation
import SwiftUI
import SwiftData

struct NewItemView: View {
    @StateObject var viewModel = NewItemViewViewModel()
    @StateObject var Keychain = KeychainManager()
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @Binding var new_item_inserted: Bool
    @Query private var items: [LoginInfoItem]
    @Environment(\.presentationMode) var presentationMode
    @State var show_alert = false
    @State var temp = "random"
    @StateObject var Notification = NotificationManager()
    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("New Login Info")
                    .font(.system(size: 30, weight: .heavy, design: .rounded))
                    .foregroundColor(shade3)
                    .padding(.top)
                
                NewFormView(title: "Website", variable: $viewModel.website, secure: false, placeholder: "Enter website name", uuid: $temp, icon: "globe")
                
                NewFormView(title: "Email", variable: $viewModel.email, secure: false, placeholder: "Enter email", uuid: $temp, icon: "envelope")
                
                NewFormView(title: "Username", variable: $viewModel.username, secure: false, placeholder: "Enter username", uuid: $temp, icon: "person")
                
                NewFormView(title: "Weblink", variable: $viewModel.weblink, secure: false, placeholder: "https://yourwebsitedomain.com", uuid: $temp, icon: "link")
                
                NewFormView(title: "Password", variable: $viewModel.password, secure: true, placeholder: "Enter password", uuid: $temp, icon: "lock")
                
                
                
                
                
                SubscriptionView(subscription: $viewModel.subscription, subscription_date: $viewModel.subscription_date)
                
                ExtrasView(extras: $viewModel.extras,
                           full_name: $viewModel.full_name,
                           address: $viewModel.address,
                           credit_card: $viewModel.credit_card,
                           date_of_birth: $viewModel.date_of_birth,
                           shade2: Color(red: 0.53, green: 0.81, blue: 0.92))
               
                
                
                LoginButtonView(title: "Save", background: shade3) {
                    if !viewModel.validate_element(website: viewModel.website, username: viewModel.username, email: viewModel.email, password: viewModel.password) {
                        show_alert = true
                    }
                    else {
                        save()
                        new_item_inserted = false
                    }
                    
                }
                .alert(isPresented: $show_alert) {
                    Alert(title: Text(viewModel.alert_title),
                          message: Text(viewModel.alert_message),
                          dismissButton: .default(Text("Ok")))
                }
                .padding(20)
            }
            
        }
    }

    func save() {
        
        
        let item = LoginInfoItem(subscription_date: viewModel.subscription_date, modification_date: Date())
        
        let keychain_item = KeychainItem(website: viewModel.website,
                                 username: viewModel.username,
                                 email: viewModel.email,
                                 weblink: viewModel.weblink,
                                 password: viewModel.password,
                                 subscription: viewModel.subscription,
                                 full_name: viewModel.full_name,
                                 address: viewModel.address,
                                 extras: viewModel.extras,
                                 credit_card: viewModel.credit_card,
                                 date_of_birth: viewModel.date_of_birth)
        context.insert(item)
        
        do {
            try Keychain.save(id: item.id, 
                              data: JSONEncoder().encode(keychain_item))
            
            Notification.add_notification(id: item.id + "password",
                                          date: Calendar.current.date(byAdding: .day, value: 90, to: item.password_modification_date)!,
                                          title: "Reminder",
                                          body: "Time to change your password for \(keychain_item.website)",
                                          repeats: false)
            
            if keychain_item.subscription {
                Notification.add_notification(id: item.id + "subscription", 
                                              date: item.subscription_date,
                                              title: "Reminder",
                                              body: "Subscription to \(keychain_item.website) expires today",
                                              repeats: false)
            }
            
            Notification.add_notification(id: item.id + "account", 
                                          date: Calendar.current.date(byAdding: .year, value: 1, to: item.password_modification_date)!,
                                          title: "Reminder",
                                          body: "Your account on \(keychain_item.website) was opened a long time ago. Still using it?",
                                          repeats: true)
            
            print("data saved correctly")
            Notification.see_pending_notifications()
        }
        catch {
            print(error)
        }
        
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return  NewItemView(new_item_inserted: Binding(get: {return true}, set: {_ in}))
            .modelContainer(container)
}
