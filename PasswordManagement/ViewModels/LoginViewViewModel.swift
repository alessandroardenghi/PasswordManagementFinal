//
//  RegistrationViewViewModel.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 18/12/23.
//

import Foundation
import SwiftUI

class LoginViewViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var error: String = ""
    @Published var is_logged_in = false
    
    init() {}
    
    func login() {
        guard check() else {
            return
        }
        
        // LOGGING IN IF ACCOUNT EXISTS
        if let saved_username = UserDefaults.standard.string(forKey: "USERNAME"), let saved_password = UserDefaults.standard.string(forKey: "PASSWORD") {
            print(saved_username)
            print(saved_password)
            if username == saved_username, password == saved_password {
                print("LOGIN SUCCESSFUL")
                error = ""
                is_logged_in = true
                
            }
            else {
                error = "Account not found"
            }
            return
        }
        
        return
    }

    func check() -> Bool{
        
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Username and Password can't be empty"
            return false
        }
        
        error = ""
        return true
        
        
        
    }
}

