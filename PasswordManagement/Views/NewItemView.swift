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
    @Environment(\.modelContext) private var context
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @Binding var new_item_inserted: Bool
    @Query private var items: [LoginInfoItem]
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("New Login Info").fontWeight(.heavy)
                    .font(.system(size: 30))
                                    .foregroundColor(.red)
                                    .padding(.top)
                
                NewFormView(title: "Website", variable: $viewModel.website, secure: false, placeholder: "Enter website name")
                
                NewFormView(title: "Email", variable: $viewModel.email, secure: false, placeholder: "Enter email")
                
                NewFormView(title: "Username", variable: $viewModel.username, secure: false, placeholder: "Enter username")
                
                NewFormView(title: "Weblink", variable: $viewModel.weblink, secure: false, placeholder: "https://yourwebsitedomain.com")
                
                if !viewModel.websiteError.isEmpty {
                    Text(viewModel.websiteError)
                        .foregroundColor(.red)
                        .padding()
                }
                

                NewFormView(title: "Password", variable: $viewModel.password, secure: true, placeholder: "Enter password")

                
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
                                if viewModel.validateWebsite() {
                                    if !isDuplicate() {
                                        save()
                                        new_item_inserted = true
                                        presentationMode.wrappedValue.dismiss()
                                    } else {
                                        viewModel.showAlert = true
                                        viewModel.alertMessage = "This website is already saved."
                                    }
                                } else {
                                    new_item_inserted = false
                                }
                            }
                            .alert(isPresented: $viewModel.showAlert) {
                                Alert(title: Text("Alert"), message: Text(viewModel.alertMessage), dismissButton: .default(Text("OK")))
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
        }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return  NewItemView(new_item_inserted: Binding(get: {return true}, set: {_ in}))
            .modelContainer(container)
}
