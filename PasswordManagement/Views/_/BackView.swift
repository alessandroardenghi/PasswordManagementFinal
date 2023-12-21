//
//  BackView.swift
//  SoftwareEngApp
//
//  Created by Alessandro Ardenghi on 19/12/23.
//

import Foundation
import SwiftUI

struct BackView: View {
    var body: some View {
        VStack {
            
            Rectangle()
                .frame(height:100)
                .foregroundColor(.orange)
                .edgesIgnoringSafeArea(.top)
            
            
            
            Rectangle()
                .frame(width: 1000, height: 100)
                .position(y: 650)
                .foregroundColor(.orange)
                .edgesIgnoringSafeArea(.bottom)
        }
        
    }
}
#Preview {
    BackView()
}
