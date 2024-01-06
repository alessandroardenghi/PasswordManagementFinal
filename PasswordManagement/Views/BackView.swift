import Foundation
import SwiftUI

struct BackView: View {
    var body: some View {
        VStack {
            
            Rectangle()
                .frame(height:100)
                .foregroundColor(.blue.opacity(0.2))
                .edgesIgnoringSafeArea(.top)
            
            
            
            Rectangle()
                .frame(width: 1000, height: 100)
                .position(y: 650)
                .foregroundColor(.blue.opacity(0.2))
                .edgesIgnoringSafeArea(.bottom)
        }
        
    }
}
#Preview {
    BackView()
}
