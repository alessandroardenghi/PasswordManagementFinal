//
//  RegistrationViewViewModel.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 18/12/23.
//

// ALE B: modificato codice: diviso check per username e password.
// aggiunto check per lunghezza minima password


import Foundation
import SwiftUI

class RegistrationViewViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var error = ""
    @Published var is_registered = false

    init() {}

    func registration() {
        guard check() else {
            return
        }

        UserDefaults.standard.set(username, forKey: "USERNAME")
        UserDefaults.standard.set(password, forKey: "PASSWORD")
        print("all set")
        is_registered = true
    }

    // Improved function to check input validity
    func check() -> Bool {
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Username can't be empty"
            return false
        }

        guard !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Password can't be empty"
            return false
        }

        guard password.count >= 8 else {
            error = "Password must be at least 8 characters long"
            return false
        }

        error = ""
        return true
    }
    
    func passwordStrengthText() -> (text: String, color: Color) {
            switch password.count {
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
