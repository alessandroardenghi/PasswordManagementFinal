//
//  LoginView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 17/12/23.
//

// ALE B: aggiungto se password buona o meno con icona --> CODICE MODIFICATO

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
                Text("paMa for you")
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
                    .border(.red, width: viewModel.error.isEmpty ? 0 : 1)

                SecureField("New Password", text: $viewModel.password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .border(viewModel.password.count >= 12 ? Color(UIColor.systemGreen) :
                            viewModel.password.count >= 8 ? Color.yellow :
                            Color.red, width: viewModel.password.isEmpty ? 0 : 1)
                
                let passwordStrength = viewModel.passwordStrengthText()
                Text(passwordStrength.text)
                    .font(.caption)
                    .foregroundColor(passwordStrength.color)
                    .padding(.bottom, 1)

                PasswordStrengthIndicator(password: $viewModel.password)

                Button(action: {
                    viewModel.registration()
                    is_registered = viewModel.is_registered
                }) {
                    Text("Create Account")
                        .foregroundColor(.white)
                        .frame(width: 280, height: 44)
                        .background(Color.blue)
                        .cornerRadius(8)
                }
                .padding()

                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                        .foregroundColor(.red)
                        .padding()
                }
            }
        }
    }
}

struct PasswordStrengthIndicator: View {
    @Binding var password: String

    private var passwordStrength: Color {
        switch password.count {
        case 0:
            return .gray
        case 1..<8:
            return .red
        case 8..<12:
            return .yellow
        default:
            return .green
        }
    }

    var body: some View {
        Rectangle()
            .frame(width: 300, height: 5)
            .foregroundColor(passwordStrength)
            .cornerRadius(2.5)
            .animation(.easeInOut, value: password.count)
    }
}
