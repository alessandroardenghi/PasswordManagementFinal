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
                
                FormView(title: "Website", variable: $viewModel.website, secure: false, placeholder: "https://yourwebsitedomain.com")
                
                if !viewModel.websiteError.isEmpty {
                    Text(viewModel.websiteError)
                        .foregroundColor(.red)
                        .padding()
                }
                
                FormView(title: "Username", variable: $viewModel.username, secure: false, placeholder: "Enter username")

                FormView(title: "Password", variable: $viewModel.password, secure: true, placeholder: "Enter password")

                
                
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
                
                FormView(title: "Name", variable: $viewModel.name, secure: false, placeholder: "Enter name")

                FormView(title: "Last Name", variable: $viewModel.last_name, secure: false, placeholder: "Enter last name")

                FormView(title: "Address", variable: $viewModel.address, secure: false, placeholder: "Enter address")
                
                LoginButtonView(title: "Save", background: .green.opacity(0.4)) {
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
                                     password: viewModel.password,
                                     subscription: viewModel.subscription,
                                     subscription_date: viewModel.subscription_date,
                                     name: viewModel.name,
                                     last_name: viewModel.last_name,
                                     address: viewModel.address)
            context.insert(item)
        }
}

#Preview {
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return  NewItemView(new_item_inserted: Binding(get: {return true}, set: {_ in}))
            .modelContainer(container)
}
