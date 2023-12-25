//
//  TutorialView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 25/12/23.
//

import Foundation
import SwiftUI
import SwiftData

struct TutorialView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @Binding var tutorial_not_seen: Bool
    @Binding var first_access: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @State var website = "Instagram"
    @State var username = "@JohnDoe"
    @State var email = "johndoe@gmail.com"
    @State var password = "password"
    @State var weblink = "https://instagram.com"
    @State var extras = true
    @State var subscription = true
    @State var subscription_date = Date()
    @State var full_name = true
    @State var date_of_birth = false
    @State var credit_card = false
    @State var address = true
    
    
    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("Tutorial").fontWeight(.heavy)
                    .font(.system(size: 30))
                    .foregroundColor(.red)
                    .padding(.top)
                
                LockedFormView(title: "Website", variable: $website, secure: false, placeholder: "Enter website name")
                Text("Insert the website name in the above cell")
                    .foregroundColor(.red)
                    .frame(width: 350)
                    .padding()
                
                LockedFormView(title: "Email", variable: $email, secure: false, placeholder: "Enter email")
                Text("Insert the email in the above cell")
                    .foregroundColor(.red)
                    .frame(width: 350)
                    .padding()
                
                LockedFormView(title: "Username", variable: $username, secure: false, placeholder: "Enter username")
                Text("Insert the username in the above cell")
                    .foregroundColor(.red)
                    .frame(width: 350)
                    .padding()
                
                LockedFormView(title: "Weblink", variable: $weblink, secure: false, placeholder: "https://yourwebsitedomain.com")
                Text("Insert the link to the login form in the above cell")
                    .foregroundColor(.red)
                    .frame(width: 350)
                    .padding()
                
                LockedFormView(title: "Password", variable: $password, secure: true, placeholder: "Enter password")
                
                
                Text("Subscription")
                    .bold()
                    .padding()
                
                Picker("Select", selection: $subscription) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)
                
                
                if subscription {
                    Text("Select End Date")
                        .bold()
                        .padding()
                    DatePicker("", selection: $subscription_date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                        .frame(width: 100)
                    
                }
                Text("Select if you have an active subscription")
                    .foregroundColor(.red)
                    .frame(width: 350)
                    .padding()
                
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
                        
                        CheckBoxView(background: .blue, variable: $full_name, text: "Full Name")
                        
                        CheckBoxView(background: .blue, variable: $address, text: "Address")
                        
                        CheckBoxView(background: .blue, variable: $credit_card, text: "Credit Card")
                        
                        CheckBoxView(background: .blue, variable: $date_of_birth, text: "Date of Birth")
                        
                    }
                    
                    
                }
                Text("Select any extra info")
                    .foregroundColor(.red)
                    .frame(width: 350)
                    .padding()
                
                
                LoginButtonView(title: "Got it!", background: .green) {
                    tutorial_not_seen = false
                    first_access = false
                }
                
                
                .padding(20)
            }
            
        }
        
    }
}

