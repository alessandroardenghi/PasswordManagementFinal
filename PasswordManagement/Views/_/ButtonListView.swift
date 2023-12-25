//
//  ButtonListView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 22/12/23.
//

// ALE B: cambiato giusto lo stile
// dovrebbe andar bene in dark&light mode

import Foundation
import SwiftUI

struct ButtonListView: View {
    
    let website: String
    let username: String
    
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        
        VStack(spacing: 10) {
            Text(website)
                .font(.headline)
                .foregroundColor(.blue)
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue.opacity(0.3))
                .cornerRadius(10)

            Text(username)
                .foregroundColor(colorScheme == .dark ? .white : .black)
                .padding()
                .frame(maxWidth: .infinity)
                .background(colorScheme == .dark ? Color.white.opacity(0.6) : Color.black.opacity(0.05))
                .cornerRadius(10)
        }
        .frame(width: 300)
        .padding()
        .background(colorScheme == .dark ? Color.black.opacity(0.2) : Color.white.opacity(0.8))
        .cornerRadius(20)
        .shadow(radius: 5)
    }
}

// Preview
struct ButtonListView_Previews: PreviewProvider {
    static var previews: some View {
        ButtonListView(website: "Insta", username: "ale")
    }
}
