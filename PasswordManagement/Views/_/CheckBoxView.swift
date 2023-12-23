//
//  GeneralPasswordView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 23/12/23.
//

import Foundation
import SwiftUI

struct GeneralPasswordButtonView: View {
    
    let background: Color
    @State var variable: Bool
    let image: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            Image(systemName: image)
                .foregroundColor(.white)
        }
        
        .frame(width: 50, height: 30)
        .background(background)
        .cornerRadius(10)
            }
        }

