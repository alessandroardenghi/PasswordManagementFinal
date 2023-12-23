//
//  PasswordButtonView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 23/12/23.
//


import Foundation
import SwiftUI

struct PasswordButtonView: View {
    let background: Color
    @State var variable: Bool
    let image1: String
    let image2: String
    let action: () -> Void
    
    var body: some View {
        
        Button(action: action) {
            
            Image(systemName: variable ? image1 : image2)
                .foregroundColor(.white)
        }
        
        .frame(width: 50, height: 30)
        .background(background)
        .cornerRadius(10)
            }
        }


/*
Button(action: {
    visible.toggle()
}) {
    Image(systemName: visible ? "eye" : "eye.slash")
        .foregroundColor(.blue)
}*/
