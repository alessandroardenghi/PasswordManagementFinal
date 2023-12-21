//
//  LoginView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 17/12/23.
//

import Foundation
import SwiftUI

struct RegistrationView: View {
    
    @StateObject var viewModel = RegistrationViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Binding var is_registered: Bool
    var body: some View {
        ZStack {
            
            BackView()
            
            VStack {
                Text("APP DI ALE & ALE")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                Text("Create a Username and a Password")
                    .padding()
                TextField("New Username", text: $viewModel.username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .border(.red, width: viewModel.error.isEmpty ? 0.0 : 1.0)
                SecureField("New Password", text: $viewModel.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .border(.red, width: viewModel.error.isEmpty ? 0.0 : 1.0)
                    
                
                
                LoginButtonView(title: "Create Account", background: .blue) {
                    viewModel.registration()
                    is_registered = viewModel.is_registered
                }
                
                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                        .foregroundColor(.red)
                        .padding()
                }
                

                
                
            }
        }
        
        
    }
    
}
    


