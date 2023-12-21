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
    
    var body: some View {
    
        if (UserDefaults.standard.string(forKey: "USERNAME") == nil || UserDefaults.standard.string(forKey: "PASSWORD") == nil) {
                RegistrationView()
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
    ContentView()
}
