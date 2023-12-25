//
//  NewFormView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 23/12/23.
//
import Foundation
import SwiftUI

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
                } else {
                    SecureField(placeholder, text: $variable)
                        .padding()
                        .disabled(locked)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
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
            }
            
        }
        
        if change_password && !locked {
               
            PasswordOptionsView(variable: $variable)
            .padding()
            .frame(maxWidth: 350)
        }
    }
    
}

