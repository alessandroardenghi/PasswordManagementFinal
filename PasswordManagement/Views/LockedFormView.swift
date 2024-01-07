import Foundation
import SwiftUI

struct LockedFormView: View {
    let title: String
    var icon: String
    @Binding var variable: String
    @Environment(\.colorScheme) var colorScheme
    let secure: Bool
    var placeholder: String
    @State var visible = false
    @State var locked = true
    @State var change_password = false
    @State private var length = 8
    @State var special_characters: Bool = true
    @State var numbers: Bool = true

    var body: some View {
        VStack(alignment: .leading) {
            Label {
                Text(title)
                    .foregroundColor(shade2)
            } icon: {
                Image(systemName: icon)
                    .foregroundColor(shade2)
            }
            .padding([.leading, .trailing])
            .font(.headline)
            
            if secure {
                
                if visible {
                    TextField(placeholder, text: $variable)
                        .padding()
                        .disabled(true)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                } 
                else {
                    SecureField(placeholder, text: $variable)
                        .padding()
                        .disabled(true)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .padding(.bottom, 10)
                }

                VStack {
                        ButtonRowView(buttonAction: {
                            visible.toggle()
                        }, icon: visible ? "eye" : "eye.slash", label: "Hide/show password")

                        ButtonRowView(buttonAction: {
                            locked.toggle()
                        }, icon: !locked ? "lock.open" : "lock", label: "Lock/unlock password")

                        ButtonRowView(buttonAction: {
                            change_password.toggle()
                        }, icon: "arrow.triangle.2.circlepath", label: "Enable the password generator")

                        ButtonRowView(buttonAction: {
                            UIPasteboard.general.string = variable
                        }, icon: "square.on.square", label: "Copy password")
                    }
                    .frame(width: 300)
            }
            
            else {
                TextField(placeholder, text: $variable)
                    .padding()
                    .bold()
                    .frame(width: 300, height: 50)
                    .disabled(true)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(7)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .padding(.bottom, 10)
            }
            
        }
        
    }
    
}

struct ButtonRowView: View {
    var buttonAction: () -> Void
    var icon: String
    var label: String
    var color: Color = shade2

    var body: some View {
        HStack {
            Button(action: buttonAction) {
                Image(systemName: icon)
                    .foregroundColor(.white).imageScale(.small)
                    .frame(width: 25, height: 25)
                    .background(color)
                    .cornerRadius(7)
            }
            Text(label)
            Spacer()
        }
    }
}

