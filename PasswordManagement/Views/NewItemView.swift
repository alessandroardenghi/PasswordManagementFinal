//
//  NewItemView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 20/12/23.
//

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

    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("New Login Info").fontWeight(.heavy)
                    .font(.system(size: 30))
                    .foregroundColor(.red)
                    .padding(.top)
                
                NewFormView(title: "Website", variable: $viewModel.website, secure: false, placeholder: "Enter website name", uuid: $temp)
                
                NewFormView(title: "Email", variable: $viewModel.email, secure: false, placeholder: "Enter email", uuid: $temp)
                
                NewFormView(title: "Username", variable: $viewModel.username, secure: false, placeholder: "Enter username", uuid: $temp)
                
                NewFormView(title: "Weblink", variable: $viewModel.weblink, secure: false, placeholder: "https://yourwebsitedomain.com", uuid: $temp)
                
                
                NewFormView(title: "Password", variable: $viewModel.password, secure: true, placeholder: "Enter password", uuid: $temp)
                
                
                Text("Subscription")
                    .bold()
                    .padding()
                
                Picker("Select", selection: $viewModel.subscription) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)
                
                
                if viewModel.subscription {
                    Text("Select End Date")
                        .bold()
                        .padding()
                    DatePicker("", selection: $viewModel.subscription_date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                        .frame(width: 100)
                    
                }
                
                Text("Extras")
                    .bold()
                    .padding()
                Picker("Select", selection: $viewModel.extras) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)
                
                if viewModel.extras {
                    VStack(alignment: .leading) {
                        
                        CheckBoxView(background: .blue, variable: $viewModel.full_name, text: "Full Name")
                        
                        CheckBoxView(background: .blue, variable: $viewModel.address, text: "Address")
                        
                        CheckBoxView(background: .blue, variable: $viewModel.credit_card, text: "Credit Card")
                        
                        CheckBoxView(background: .blue, variable: $viewModel.date_of_birth, text: "Date of Birth")
                        
                    }
                    
                    
                }
                
                
                LoginButtonView(title: "Save", background: .green) {
                    if !viewModel.validate_element() {
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
    func isDuplicate() -> Bool {
           return items.contains(where: { $0.website == viewModel.website })
       }

    func save() {
        let item = LoginInfoItem(website: viewModel.website,
                                 username: viewModel.username,
                                 email: viewModel.email,
                                 weblink: viewModel.weblink,
                                 password: viewModel.password,
                                 subscription: viewModel.subscription,
                                 subscription_date: viewModel.subscription_date,
                                 full_name: viewModel.full_name,
                                 address: viewModel.address,
                                 credit_card: viewModel.credit_card,
                                 date_of_birth: viewModel.date_of_birth)
        context.insert(item)
        /*
        do {
            try Keychain.save(id: item.id, data: JSONEncoder().encode(item))
        }
        catch {
            print(error)
        }
        */
    }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return  NewItemView(new_item_inserted: Binding(get: {return true}, set: {_ in}))
            .modelContainer(container)
}
