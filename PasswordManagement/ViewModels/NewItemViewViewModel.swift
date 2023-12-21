//
//  NewItemViewViewModel.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 20/12/23.
//

import Foundation
import SwiftUI
import SwiftData

class NewItemViewViewModel: ObservableObject {
    
    @Environment(\.modelContext) private var context
    @Published var website: String = ""
    @Published var username: String = ""
    @Published var password: String = ""
    @Published var subscription: Bool = false
    @Published var subscription_date: Date = Date()
    @Published var name: String = ""
    @Published var last_name: String = ""
    @Published var address: String = ""
    
    init() {}
    
    func save() {
        let item = LoginInfoItem(website: website,
                                 username: username,
                                 password: password,
                                 subscription: subscription, 
                                 subscription_date: subscription_date,
                                 name: name,
                                 last_name: last_name,
                                 address: address)
        
    }
    
    
}

