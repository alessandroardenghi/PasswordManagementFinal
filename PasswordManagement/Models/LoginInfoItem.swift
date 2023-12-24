//
//  LoginInfo.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 18/12/23.
//

import Foundation
import SwiftData

@Model
final class LoginInfoItem : Identifiable {
    
    @Attribute(.unique) var id: String
    var website: String
    var username: String
    var email: String
    var weblink: String
    var password: String
    var subscription: Bool
    var subscription_date: Date = Date()
    var full_name: Bool
    var address: Bool
    var credit_card: Bool
    var date_of_birth: Bool
    var bookmark: Bool
    
    init(website: String,
         username: String,
         email: String,
         weblink: String,
         password: String,
         subscription: Bool,
         subscription_date: Date = Date(),
         full_name: Bool,
         address: Bool,
         credit_card: Bool,
         date_of_birth: Bool) {
        
        self.id = UUID().uuidString
        self.website = website
        self.username = username
        self.email = email
        self.weblink = weblink
        self.password = password
        self.subscription = subscription
        self.subscription_date = subscription_date
        self.full_name = full_name
        self.address = address
        self.credit_card = credit_card
        self.date_of_birth = date_of_birth
        self.bookmark = false
    }
}
