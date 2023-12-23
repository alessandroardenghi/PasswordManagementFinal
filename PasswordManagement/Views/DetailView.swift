//
//  DetailView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 22/12/23.
//

import Foundation
import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @State var variable: LoginInfoItem
    @State private var showWebView = false
    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("Login Info")
                    .bold()
                    .font(.system(size: 30))
                    .padding()
                
                FormView(title: "Website", variable: $variable.website, secure: false, placeholder: "Enter website")
                
                FormView(title: "Email", variable: $variable.email, secure: false, placeholder: "Enter email")
                
                FormView(title: "Weblink", variable: $variable.weblink, secure: false, placeholder: "https://yourwebsite.com")
                
                FormView(title: "Username", variable: $variable.username, secure: false, placeholder: "Enter username")
                
                FormView(title: "Password", variable: $variable.password, secure: true, placeholder: "Enter password")
                
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
                }
                
                FormView(title: "Name", variable: $variable.name, secure: false, placeholder: "Enter name")
                
                FormView(title: "Last Name", variable: $variable.last_name, secure: false, placeholder: "Enter last name")
                
                FormView(title: "Address", variable: $variable.address, secure: false, placeholder: "Enter address")
                
                Button("Open Web Page") {
                                   showWebView = true
                               }
                               .sheet(isPresented: $showWebView) {
                                   if let url = URL(string: variable.website) {
                                       WebView(url: url)
                                   }
                               }
            }
            .padding(20)
        }
    }
}
