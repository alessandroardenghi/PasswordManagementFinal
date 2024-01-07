import Foundation
import SwiftUI

class NewFormViewViewModel: ObservableObject {
    @Published var password: String = ""
    @Published var username: String = ""
    @Published var error: String = ""
    @Published var is_logged_in = false
    
    init() {}
    
    
}
