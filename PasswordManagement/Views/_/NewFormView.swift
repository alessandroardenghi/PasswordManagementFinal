//
//  NewFormView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 23/12/23.
//
import Foundation
import SwiftUI
import SwiftData

struct NewFormView: View {
    let title: String
    @Binding var variable: String
    @Environment(\.colorScheme) var colorScheme
    let secure: Bool
    var placeholder: String
    @State var visible = false
    @State var locked = true
    @State var change_password = false
    @State private var length = 8
    @State var special_characters: Bool = true
    @State var numbers: Bool = true
    @State var alert_text = ""
    @State var show_password_error = false
    @State var show_weblink_error = false
    @State var show_website_error = false
    @Binding var uuid: String
    
    @Environment(\.modelContext) var context
    @Query private var items: [LoginInfoItem]
    
    
    
    var body: some View {
        
        
        VStack (spacing: 2) {
            
            Text(title)
                .bold()
                .padding()
            
            if secure {
                
                if visible {
                    TextField(placeholder, text: $variable)
                        .padding()
                        .disabled(locked)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onChange(of: variable) {
                            if !validate_password(variable: variable) {
                                show_password_error = true
                            }
                        }
                } else {
                    SecureField(placeholder, text: $variable)
                        .padding()
                        .disabled(locked)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onChange(of: variable) {
                            if !validate_password(variable: variable) {
                                show_password_error = true
                            }
                        }
                }
                
                if show_password_error {
                    Text(alert_text)
                        .foregroundColor(.red)
                        .bold()
                }
                
                HStack(spacing: 25) {
                    
                    // BUTTON TO SEE PASSWORD
                    Button(action: {
                        visible.toggle()
                    }) {
                        Image(systemName: visible ? "eye" : "eye.slash")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                    
                    // BUTTON TO LOCK PASSWORD
                    Button(action: {
                        locked.toggle()
                    }) {
                        Image(systemName: !locked ? "lock.open" : "lock")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                    
                    // BUTTON TO CHANGE PASSWORD
                    Button(action: {
                        change_password.toggle()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                    
                    // BUTTON TO COPY PASSWORD
                    Button(action: {
                        UIPasteboard.general.string = variable
                    }) {
                        Image(systemName: "square.on.square")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                }
            } else {
                TextField(placeholder, text: $variable)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .onChange(of: variable) {
                        if title == "Weblink" && !validate_weblink(variable: variable) {
                            show_weblink_error = true
                        }
                        if title == "Website" && !validate_website(variable: variable) {
                            show_website_error = true
                        }
                    }
                    
            }
           
            if show_weblink_error {
                Text(alert_text)
                    .foregroundColor(.red)
                    .bold()
            }
            if show_website_error {
                Text(alert_text)
                    .foregroundColor(.red)
                    .bold()
            }
            
        }
        
        if change_password && !locked {
               
            PasswordOptionsView(variable: $variable)
            .padding()
            .frame(maxWidth: 350)
        }
    }
    
    func validate_password(variable: String) -> Bool {
        if variable.count < 8 {
            alert_text = "Password too short"
            return false
        }
        for item in items {
            if uuid != item.id && LCS(KeychainManager().get(id: item.id)!.password, variable) > 4 {
                alert_text = "password too similar to another stored password"
                return false
            }
        }
        alert_text = ""
        return true
    }
    
    func LCS(_ str1: String, _ str2: String) -> Int {
        let length1 = str1.count
        let length2 = str2.count
        
        var max_length = 0
        
        var matrix = Array(repeating: Array(repeating: 0, count: length2 + 1), count: length1 + 1)
        
        for i in 1...length1 {
            for j in 1...length2 {
                if str1[str1.index(str1.startIndex, offsetBy: i - 1)] == str2[str2.index(str2.startIndex, offsetBy: j - 1)] {
                    matrix[i][j] = matrix[i - 1][j - 1] + 1
                    if matrix[i][j] > max_length {
                        max_length = matrix[i][j]
                    }
                }
            }
        }
        print(max_length)
        return max_length
    }
    
    func validate_weblink(variable: String) -> Bool {
        
        if variable.isEmpty {
            alert_text = "Are you sure you want to leave this field empty?"
            return false
        }
        
        else if variable.hasPrefix("http://") || variable.hasPrefix("https://") {
            alert_text = ""
            return true
        }
        else {
            alert_text = "Invalid form. Write the URL as: http://yourwebsite.com"
            return false
        }
    }
    
    func validate_website(variable: String) -> Bool {
        if variable.isEmpty {
            alert_text = "website can't be empty"
            return false
        }
        
        else {
            alert_text = ""
            return true
        }
    }
    
}

