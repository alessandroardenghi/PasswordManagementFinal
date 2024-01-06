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
    @StateObject var Keychain = KeychainManager()
    
    var body: some View {
    
        if !is_registered && (Keychain.get(id: "main_login_info") == nil) {
                RegistrationView(is_registered: $is_registered)
        } else {
            
            if is_logged_in {
                mainView
            }
            else {
                LoginView(is_logged_in: $is_logged_in)
            }
        }
    }
    
    @ViewBuilder
    var mainView: some View {
        TabView {
            ListView()
                .tabItem {
                    Label("Home", systemImage: "house")
                }
            SummaryView()
                .tabItem {
                    Label("Summary", systemImage: "chart.bar")
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
