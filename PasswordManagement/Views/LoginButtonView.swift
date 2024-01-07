import Foundation
import SwiftUI

struct LoginButtonView: View {
    let title: String
    let background: Color
    let action: () -> Void
    
    var body: some View {
        Button(title)
        {
            action()
        }
        .foregroundColor(.white)
        .frame(width: 300, height: 50)
        .background(background)
        .cornerRadius(10)
    }
}



