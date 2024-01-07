import Foundation
import SwiftUI

struct LoginView: View {
    
    @StateObject var viewModel = LoginViewViewModel()
    @Environment(\.colorScheme) var colorScheme
    @Binding var is_logged_in: Bool
    @State var visible = false
    
    var body: some View {
        ZStack {
            
            BackView()
            
            VStack {
                Text("Welcome back!")
                    .font(.system(size: 44, weight: .bold, design: .rounded))
                Text("Insert your Username and a Password")
                    .padding(2)
                TextField("Username", text: $viewModel.username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .border(.red, width: viewModel.error.isEmpty ? 0.0 : 1.0)
                
                ZStack(alignment: .trailing) {
    
                    if !visible {
                        SecureField("Password", text: $viewModel.password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                            .cornerRadius(10)
                            .border(.red, width: viewModel.error.isEmpty ? 0.0 : 1.0)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    } else {
                        TextField("Password", text: $viewModel.password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                            .cornerRadius(10)
                            .border(.red, width: viewModel.error.isEmpty ? 0.0 : 1.0)
                            .autocapitalization(.none)
                            .autocorrectionDisabled()
                    }
                    
                    Button(action: {
                                    visible.toggle()
                                }) {
                                    Image(systemName: visible ? "eye" : "eye.slash")
                                        .foregroundColor(.blue)
                                        .padding()
                                }
                }
                LoginButtonView(title: "Login", background: .blue) {
                    viewModel.login()
                    is_logged_in = viewModel.is_logged_in
                }
                if !viewModel.error.isEmpty {
                    Text(viewModel.error)
                        .foregroundColor(.red)
                        .padding()
                
                
                .padding(.bottom, 100)
                
                }
            }
            
        }
        
    }
    
}

#Preview {
    LoginView(is_logged_in: Binding(get: {return true}, set: {_ in}))
}
