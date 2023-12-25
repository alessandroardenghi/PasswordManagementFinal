//
//  TutorialViewHelper.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 25/12/23.
//

import Foundation
import SwiftUI

struct LockedFormView: View {
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
                        .disabled(true)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                } else {
                    SecureField(placeholder, text: $variable)
                        .padding()
                        .disabled(true)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                }
                
                
                    
                // BUTTON TO SEE PASSWORD
                HStack{
                    Button(action: {
                        visible.toggle()
                    }) {
                        Image(systemName: visible ? "eye" : "eye.slash")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                    Spacer()
                    Text("Hide/show password")
                }
                .frame(width: 300)
                // BUTTON TO LOCK PASSWORD
                HStack{
                    Button(action: {
                        locked.toggle()
                    }) {
                        Image(systemName: !locked ? "lock.open" : "lock")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                    Spacer()
                    Text("Lock/unlock password")
                }
                .frame(width: 300)
                // BUTTON TO CHANGE PASSWORD
                HStack {
                    Button(action: {
                        change_password.toggle()
                    }) {
                        Image(systemName: "arrow.triangle.2.circlepath")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                    Spacer()
                    Text("Enable the password generator")
                }
                .frame(width: 300)
                // BUTTON TO COPY PASSWORD
                HStack {
                    Button(action: {
                        UIPasteboard.general.string = variable
                    }) {
                        Image(systemName: "square.on.square")
                            .foregroundColor(.white)
                    }
                    
                    .frame(width: 50, height: 30)
                    .background(.blue)
                    .cornerRadius(10)
                    Spacer()
                    Text("Copy password")
                }
                .frame(width: 300)
            } else {
                TextField(placeholder, text: $variable)
                    .padding()
                    .bold()
                    .frame(width: 300, height: 50)
                    .disabled(true)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
            
        }
        
    }
    
}


