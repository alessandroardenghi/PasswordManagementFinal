import Foundation
import SwiftUI
import SwiftData

class ListViewViewModel: ObservableObject {
    @Published var new_item = false
    @Environment(\.modelContext) var context
    @Query private var items: [LoginInfoItem]
    @State var Keychain = KeychainManager()
    
    
    class KIandLIT: Identifiable {
        @Attribute(.unique) var id: String
        var secure_variable: KeychainItem
        var item: LoginInfoItem
        
        init(secure_variable: KeychainItem, item: LoginInfoItem) {
            
            self.id = UUID().uuidString
            self.secure_variable = secure_variable
            self.item = item
        }
    }

    @Published var secure_variables: [KIandLIT] = []

    func getItemsFromKeychain(items: [LoginInfoItem]){
        
        for item in items {
            if let keychainItem = Keychain.get(id: item.id) {
                secure_variables.append(KIandLIT(secure_variable: keychainItem, item: item))
                }
            }
    }
    
    
}
