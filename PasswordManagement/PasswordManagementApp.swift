//
//  PasswordManagementApp.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 21/12/23.
//

import SwiftUI
import SwiftData

@main
struct PasswordManagementApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: LoginInfoItem.self)
    }
}
