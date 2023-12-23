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
    var password: String
    var subscription: Bool
    var subscription_date: Date = Date()
    var name: String
    var last_name: String
    var address: String
    
    init(website: String,
         username: String,
         password: String,
         subscription: Bool,
         subscription_date: Date = Date(),
         name: String,
         last_name: String,
         address: String) {
        
        self.id = UUID().uuidString
        self.website = website
        self.username = username
        self.password = password
        self.subscription = subscription
        self.subscription_date = subscription_date
        self.name = name
        self.last_name = last_name
        self.address = address
    }
}
