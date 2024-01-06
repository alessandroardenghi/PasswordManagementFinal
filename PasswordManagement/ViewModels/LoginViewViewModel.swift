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
    @Published var Keychain = KeychainManager()
    
    init() {}
    
    func login() {
        guard check() else {
            return
        }
        
        if let saved_username = Keychain.get(id: "main_login_info")?.username, let saved_password = Keychain.get(id: "main_login_info")?.password {
            
            if username == saved_username, password == saved_password {
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

