import Foundation
import SwiftData

@Model
final class LoginInfoItem : Identifiable{
    
    @Attribute(.unique) var id: String
    var subscription_date: Date = Date()
    var bookmark: Bool
    var modification_date: Date
    let account_creation_date: Date
    var password_modification_date: Date
    
    init(subscription_date: Date = Date(), modification_date: Date) {
        
        self.id = UUID().uuidString
        self.subscription_date = subscription_date
        self.bookmark = false
        self.modification_date = modification_date
        self.account_creation_date = Date()
        self.password_modification_date = Date()
    }
}
