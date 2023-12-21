//
//  Item.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 21/12/23.
//

import Foundation
import SwiftData

@Model
final class Item {
    var timestamp: Date
    
    init(timestamp: Date) {
        self.timestamp = timestamp
    }
}
