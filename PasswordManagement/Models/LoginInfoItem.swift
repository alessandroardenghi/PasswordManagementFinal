//
//  LoginInfo.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 18/12/23.
//

import Foundation
import SwiftData

@Model
final class LoginInfoItem : Identifiable{
    
    @Attribute(.unique) var id: String
    var subscription_date: Date = Date()
    var bookmark: Bool
    var modification_date: Date
    
    init(subscription_date: Date = Date(), modification_date: Date) {
        
        self.id = UUID().uuidString
        self.subscription_date = subscription_date
        self.bookmark = false
        self.modification_date = modification_date
    }
}
