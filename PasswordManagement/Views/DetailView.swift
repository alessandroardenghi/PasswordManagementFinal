//
//  DetailView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 22/12/23.
//

import Foundation
import SwiftUI
import SwiftData

// protocol used for web automation --> triggered when an action is called
protocol WebAutomationDelegate {
    func performAction(username: String, password: String, url: String, actionType: ActionType)
}
// callable actions by the user --> these are the buttons the user sees and that trigger
// our protocol. if the automation fails, we have a backup case where the user manually
// enters all the data
enum ActionType {
    case changePassword
    case deleteAccount
    case deleteSubscription
}

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @State var variable: LoginInfoItem
    @State private var showWebView = false
    @State var extras: Bool = false
    var automationDelegate: WebAutomationDelegate?
    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("Login Info")
                    .bold()
                    .font(.system(size: 30))
                    .padding()
                
                NewFormView(title: "Website", variable: $variable.website, secure: false, placeholder: "Enter website")
                
                NewFormView(title: "Email", variable: $variable.email, secure: false, placeholder: "Enter email")
                
                NewFormView(title: "Weblink", variable: $variable.weblink, secure: false, placeholder: "https://yourwebsite.com")
                
                NewFormView(title: "Username", variable: $variable.username, secure: false, placeholder: "Enter username")
                
                NewFormView(title: "Password", variable: $variable.password, secure: true, placeholder: "Enter password")
                
                Text("Subscription")
                    .bold()
                    .padding()
                
                Picker("Select", selection: $variable.subscription) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)
                
                if variable.subscription {
                    Text("Select End Date")
                        .bold()
                        .padding()
                    DatePicker("", selection: $variable.subscription_date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                        .frame(width: 100)

                    Spacer()
                    
                    Button(action: {
                                        performWebAction(actionType: .deleteSubscription)
                                    }) {
                                        Text("Delete Subscription")
                                            .frame(width: 250, height: 30)
                                            .padding()
                                            .foregroundColor(.white)
                                            .background(Color.blue)
                                            .cornerRadius(10)
                                    }
                }
                
                Text("Extras")
                    .bold()
                    .padding()
                Picker("Select", selection: $extras) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)
                
                if extras {
                    VStack(alignment: .leading) {
                        CheckBoxView(background: .blue, variable: $variable.full_name, text: "Full Name")
                        
                        CheckBoxView(background: .blue, variable: $variable.address, text: "Address")
                        
                        CheckBoxView(background: .blue, variable: $variable.credit_card, text: "Credit Card")
                        
                        CheckBoxView(background: .blue, variable: $variable.date_of_birth, text: "Date of Birth")
                        
                    }
                }
                
                Button(action: {
                            showWebView = true
                            performWebAction(actionType: .changePassword)
                        }) {
                            Text("Change Password")
                                .frame(width: 250, height: 30)
                                .padding()
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .cornerRadius(10)
                        }
                        .sheet(isPresented: $showWebView) {
                            if let url = URL(string: variable.weblink) {
                                WebView(url: url, username: variable.username, password: variable.password)
                            }
                        }
                
                Spacer()
                
                Button(action: {
                                    performWebAction(actionType: .deleteAccount)
                                }) {
                                    Text("Delete Account")
                                        .frame(width: 250, height: 30)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
            }
            .padding(20)
        }
    }
    private func performWebAction(actionType: ActionType) {
                automationDelegate?.performAction(username: variable.username,
                                                  password: variable.password,
                                                  url: variable.weblink,
                                                  actionType: actionType)
            }
}
