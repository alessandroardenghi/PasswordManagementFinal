//
//  NewItemViewViewModel.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 20/12/23.
//

// ALE B: make sure the URL is valid

import Foundation
import SwiftUI
import SwiftData

class NewItemViewViewModel: ObservableObject {
    // Variables to create model
    @Published var website: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var weblink: String = ""
    @Published var subscription: Bool = false
    @Published var subscription_date: Date = Date()
    @Published var extras: Bool = false
    @Published var full_name: Bool = false
    @Published var address: Bool = false
    @Published var credit_card: Bool = false
    @Published var date_of_birth: Bool = false
    @Published var websiteError = ""
    // Variables to handle validation
    @Published var alert_title = ""
    @Published var alert_message = ""

    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    @Environment(\.modelContext) private var context
    
    init() {}
    
    // Function to validate the website name
    
    
    func validate_element() -> Bool {
        
        if self.website.isEmpty {
            alert_title = "website is empty"
            alert_message = "please fill up the website"
            return false
        }
        
        if (self.username.isEmpty && self.email.isEmpty) {
            alert_title = "both email and username are empty"
            alert_message = "please fill up either one"
            return false
        }
        
        if self.password.isEmpty {
            alert_title = "password is empty"
            alert_message = "please insert a valid password"
            return false
        }
        return true
    }
    
}
