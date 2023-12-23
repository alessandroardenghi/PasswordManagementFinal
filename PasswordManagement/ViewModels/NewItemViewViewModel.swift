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
    @Published var website: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var email: String = ""
    @Published var weblink: String = ""
    @Published var subscription: Bool = false
    @Published var subscription_date: Date = Date()
    @Published var name: String = ""
    @Published var last_name: String = ""
    @Published var address: String = ""
    @Published var websiteError: String = ""
    @Published var showAlert: Bool = false
    @Published var alertMessage: String = ""
    
    init() {}
    
    // Function to validate the website URL
    func validateWebsite() -> Bool {
        if weblink.hasPrefix("http://") || weblink.hasPrefix("https://") {
            websiteError = ""
            return true
        } else {
            websiteError = "Invalid form. Write the URL as: http://yourwebsite.com"
            showAlertWithTimer()
            return false
        }
    }

    func showAlertWithTimer() {
        self.showAlert = true
        self.alertMessage = "Invalid URL format. Please correct it."

        // to dismiss the alert after 3 seconds, so the user can actually read the message
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            self.showAlert = false
        }
    }

}
