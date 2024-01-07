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
    
    func validate_element(website: String, username: String, email: String, password: String) -> Bool {
        
        if website.isEmpty {
            alert_title = "Website is empty"
            alert_message = "Please fill up the website"
            return false
        }
        
        if (username.isEmpty && email.isEmpty) {
            alert_title = "Both email and username are empty"
            alert_message = "Please fill up either one"
            return false
        }
        
        if password.isEmpty {
            alert_title = "Password is empty"
            alert_message = "Please insert a valid password"
            return false
        }
        return true
    }
    
}
