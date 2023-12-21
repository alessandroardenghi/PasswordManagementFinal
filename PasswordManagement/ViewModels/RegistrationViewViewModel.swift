//
//  RegistrationViewViewModel.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 18/12/23.
//

import Foundation
import SwiftUI

class RegistrationViewViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var error = ""
    
    init() {}
    
    func registration() {
        guard check() else {
            return
        }
        
        UserDefaults.standard.set(username, forKey: "USERNAME")
        UserDefaults.standard.set(password, forKey: "PASSWORD")
        print("all set")
        

        // Print all keys and their associated values
        if let value = UserDefaults.standard.string(forKey: "PASSWORD") {
            print("Key: PASSWORD, Value: \(value)")
        }
        if let value = UserDefaults.standard.string(forKey: "USERNAME") {
            print("Key: USERNAME, Value: \(value)")
        }
        
    }
    
    
    // FUNCTION TO CHECK --> CAN BE IMPROVED
    func check() -> Bool{
        
        guard !username.trimmingCharacters(in: .whitespaces).isEmpty, !password.trimmingCharacters(in: .whitespaces).isEmpty else {
            error = "Username and Password can't be empty"
            return false
        }
        
        error = ""
        return true
        
        
        
    }
    
}
