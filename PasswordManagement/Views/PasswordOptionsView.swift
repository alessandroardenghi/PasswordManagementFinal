//
//  PasswordMenuView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 25/12/23.
//
import Foundation
import SwiftUI

struct PasswordOptionsView: View {
    @Binding var variable: String
    @State private var passwordLength: Double = 8
    @State private var includeSpecialCharacters = false
    @State private var includeNumbers = false
    @State private var generatedPassword = ""
    
    var body: some View {
        VStack {
            Text("Password Options")
                .bold()
                .padding()
            
            Text("Password Length: \(Int(passwordLength))")
            Slider(value: $passwordLength, in: 4...26, step: 1)
                .padding()
            
            Toggle("Include Special Characters", isOn: $includeSpecialCharacters)
                .padding()
            
            Toggle("Include Numbers", isOn: $includeNumbers)
                .padding()
            
            PasswordStrengthIndicator(password: $variable)
            let password_strength = password_strength_func(variable: variable)
            Text(password_strength.text)
                .font(.caption)
                .foregroundColor(password_strength.color)
                .padding(.bottom, 1)

            
            Button("Generate Password") {
                generatedPassword = generatePassword()
                variable = generatedPassword // Set the generated password to the box
            }
            .padding()
        }
        .padding()
        .background(Color.gray.opacity(0.1))
        .cornerRadius(10)
    }
    
    func generatePassword() -> String {

        var allowedCharacters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"
        if includeSpecialCharacters {
            allowedCharacters += "!@#$%^&*()_+-=[]{}|;:,.<>?`~"
        }
        if includeNumbers {
            allowedCharacters += "0123456789"
        }
        
        let password_length = Int(passwordLength)
        let password = String((0..<password_length).compactMap { _ in
            allowedCharacters.randomElement()
        })
        
        return password
    }
    
    func password_strength_func(variable: String) -> (text: String, color: Color) {
            switch variable.count {
            case 0:
                return ("Enter a password", .gray)
            case 1..<8:
                return ("Password strength: Weak", .red)
            case 8..<12:
                return ("Password strength: Moderate", .yellow)
            default:
                return ("Password strength: Good", .green)
            }
        }
}
