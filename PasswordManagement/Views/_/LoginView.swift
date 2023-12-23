//
//  LoginView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 17/12/23.
//

// ALE B: login ok, forse cambiare grafica ma overall CHECKED

import Foundation
import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Binding var is_logged_in: Bool
    var body: some View {
        ZStack {
            
            BackView()
            
            VStack {
                Text("APP DI ALE & ALE")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Text("Insert your Username and a Password")
                    .padding()
                TextField("Username", text: $viewModel.username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .border(.red, width: viewModel.error.isEmpty ? 0.0 : 1.0)
                SecureField("Password", text: $viewModel.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .border(.red, width: viewModel.error.isEmpty ? 0.0 : 1.0)
                
                
                LoginButtonView(title: "Login", background: .blue) {
                    viewModel.login()
                    is_logged_in = viewModel.is_logged_in
                }
                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                        .foregroundColor(.red)
                        .padding()
                
                
                .padding(.bottom, 100)
                
                }
            }
            
        }
        
        
    }
    
}

