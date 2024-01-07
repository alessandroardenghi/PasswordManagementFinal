import Foundation
import SwiftUI

struct CheckBoxView: View {
    
    let background: Color
    @Binding var variable: Bool
    let text: String
    
    var body: some View {
        
        HStack(spacing: 20) {
            Text(text)
            Spacer()
            Button(action: {
                variable.toggle()
            }) {
                Image(systemName: !variable ? "square" : "checkmark.square.fill")
                    .foregroundColor(.white)
            }
            
            .frame(width: 30, height: 30)
            .background(shade2)
            .cornerRadius(7)
        }
        .padding(.horizontal, 50)
    }
}

