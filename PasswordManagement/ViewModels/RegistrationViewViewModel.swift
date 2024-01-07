import Foundation
import SwiftUI

class RegistrationViewViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var error = ""
    @Published var is_registered = false
    @Published var Keychain = KeychainManager()
    @State var id: String =  "main_login_info"
    
    init() {}

    func registration() {
        guard check() else {
            return
        }
        
        let login_info = KeychainItem(website: "", username: username, email: "", weblink: "", password: password, subscription: false, full_name: false, address: false, extras: false, credit_card: false, date_of_birth: false)
        
        do {
            try Keychain.save(id: id, data: JSONEncoder().encode(login_info))
        }
        catch {
            print(error)
        }
        
        is_registered = true
    }

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
