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
    @State var extras: Bool = false
    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("Login Info")
                    .bold()
                    .font(.system(size: 30))
                    .padding()
                
                NewFormView(title: "Website", variable: $variable.website, secure: false, placeholder: "Enter website", uuid: $variable.id)
                
                NewFormView(title: "Email", variable: $variable.email, secure: false, placeholder: "Enter email", uuid: $variable.id)
                
                NewFormView(title: "Weblink", variable: $variable.weblink, secure: false, placeholder: "https://yourwebsite.com", uuid: $variable.id)
                
                NewFormView(title: "Username", variable: $variable.username, secure: false, placeholder: "Enter username", uuid: $variable.id)
                
                NewFormView(title: "Password", variable: $variable.password, secure: true, placeholder: "Enter password", uuid: $variable.id)
                
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
                
                Button("Open Web Page") {
                    showWebView = true
                }
                .sheet(isPresented: $showWebView) {
                    if let url = URL(string: variable.weblink) {
                        WebView(url: url)
                    }
                }
            }
            .padding(20)
        }
    }
    
}
