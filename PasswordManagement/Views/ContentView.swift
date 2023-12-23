//
//  ContentView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 17/12/23.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    
    @State var is_logged_in = false
    @State var is_registered = false
    
    var body: some View {
    
        if !is_registered && (UserDefaults.standard.string(forKey: "USERNAME") == nil || UserDefaults.standard.string(forKey: "PASSWORD") == nil) {
                RegistrationView(is_registered: $is_registered)
        }
        else {
            
            if is_logged_in {
                ListView()
            }
            else {
                LoginView(is_logged_in: $is_logged_in)
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return ContentView()
            .modelContainer(container)
}
