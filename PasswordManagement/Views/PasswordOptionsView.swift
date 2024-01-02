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
        // Implement password generation logic based on selected settings
        // Generate a random password string and return it
        // Use `passwordLength`, `includeSpecialCharacters`, `includeNumbers`, etc.
        // to customize the generated password
        
        // Sample code (modify as per your requirements)
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
}
