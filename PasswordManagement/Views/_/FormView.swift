//
//  FormView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 20/12/23.
//

import Foundation
import SwiftUI

struct FormView: View {
    let title: String
    @Binding var variable: String
    @Environment(\.colorScheme) var colorScheme
    let secure: Bool
    var placeholder: String
    @State var visible = false
    @State var locked = false

    var body: some View {
        VStack (spacing: 2) {
            HStack {
                Text(title)
                    .bold()
                    .padding()
                if secure {
                    Button(action: {
                        locked.toggle()
                    }) {
                        Image(systemName: locked ? "lock" : "lock.open")
                            .foregroundColor(.blue)
                    }
                }
            }
            if secure {
                ZStack(alignment: .trailing) {
                    if visible {
                        TextField(placeholder, text: $variable)
                            .padding()
                            .disabled(locked)
                            .frame(width: 300, height: 50)
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    } else {
                        SecureField(placeholder, text: $variable)
                            .padding()
                            .disabled(locked)
                            .frame(width: 300, height: 50)
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                            .cornerRadius(10)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    Button(action: {
                        visible.toggle()
                    }) {
                        Image(systemName: visible ? "eye" : "eye.slash")
                            .foregroundColor(.blue)
                    }
                }
            } else {
                TextField(placeholder, text: $variable)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
            }
        }
    }
}
