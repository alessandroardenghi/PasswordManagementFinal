import Foundation
import SwiftUI
import SwiftData

struct NewFormView: View {
    let title: String
    @Binding var variable: String
    @Environment(\.colorScheme) var colorScheme
    let secure: Bool
    var placeholder: String
    @State var visible = false
    @State var locked = true
    @State var change_password = false
    @State var length = 8
    @State var special_characters: Bool = true
    @State var numbers: Bool = true
    @State var alert_text = ""
    @State var show_password_error = false
    @State var show_weblink_error = false
    @State var show_website_error = false
    @Binding var uuid: String
    @Environment(\.modelContext) var context
    @Query private var items: [LoginInfoItem]
    
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 2) {
            
            Text(title)
                .font(.headline)
                .foregroundColor(shade2)
                .padding(.top)
                .padding(.bottom, 5)
            
            if secure {
                
                if visible {
                    TextField(placeholder, text: $variable)
                        .padding()
                        .disabled(locked)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color(UIColor.systemGray6))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onChange(of: variable) {
                            if !validate_password(variable: variable) {
                                show_password_error = true
                            }
                        }
                } else {
                    SecureField(placeholder, text: $variable)
                        .padding()
                        .disabled(locked)
                        .frame(width: 300, height: 50)
                        .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                        .cornerRadius(10)
                        .autocapitalization(.none)
                        .autocorrectionDisabled()
                        .onChange(of: variable) {
                            if !validate_password(variable: variable) {
                                show_password_error = true
                            }
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.leading)
                }
                
                
                if show_password_error {
                    Text(alert_text)
                        .foregroundColor(.red)
                        .bold()
                }
                
                HStack(spacing: 8) {
                   ButtonRowView2(buttonAction: { visible.toggle() }, icon: visible ? "eye" : "eye.slash")
                   ButtonRowView2(buttonAction: { locked.toggle() }, icon: !locked ? "lock.open" : "lock")
                   ButtonRowView2(buttonAction: { change_password.toggle() }, icon: "arrow.triangle.2.circlepath")
                   ButtonRowView2(buttonAction: { UIPasteboard.general.string = variable }, icon: "square.on.square")
               }
               .frame(width: 300)
               .padding(.horizontal, 10)
               .padding(.top, 5)
           }
                           
            else {
                TextField(placeholder, text: $variable)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(colorScheme == .dark ? Color.white.opacity(0.1) : Color.black.opacity(0.1))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                    .autocorrectionDisabled()
                    .onChange(of: variable) {
                        if title == "Weblink" && !validate_weblink(variable: variable) {
                            show_weblink_error = true
                        }
                        if title == "Website" && !validate_website(variable: variable) {
                            show_website_error = true
                        }
                    }
                    
            }
           
            if show_weblink_error {
                Text(alert_text)
                    .foregroundColor(.red)
                    .bold()
            }
            if show_website_error {
                Text(alert_text)
                    .foregroundColor(.red)
                    .bold()
            }
            
        }
        
        if change_password && !locked {
               
            PasswordOptionsView(variable: $variable)
            .padding()
            .frame(maxWidth: 350)
        }
    }
    
    func validate_password(variable: String) -> Bool {
        if variable.count < 8 {
            alert_text = "Password too short"
            return false
        }
        for item in items {
            if uuid != item.id && LCS(KeychainManager().get(id: item.id)!.password, variable) > 4 {
                alert_text = "password too similar to another stored password"
                return false
            }
        }
        alert_text = ""
        return true
    }
    
    func LCS(_ str1: String, _ str2: String) -> Int {
        let length1 = str1.count
        let length2 = str2.count
        
        var max_length = 0
        
        var matrix = Array(repeating: Array(repeating: 0, count: length2 + 1), count: length1 + 1)
        
        for i in 1...length1 {
            for j in 1...length2 {
                if str1[str1.index(str1.startIndex, offsetBy: i - 1)] == str2[str2.index(str2.startIndex, offsetBy: j - 1)] {
                    matrix[i][j] = matrix[i - 1][j - 1] + 1
                    if matrix[i][j] > max_length {
                        max_length = matrix[i][j]
                    }
                }
            }
        }
        
        return max_length
    }
    
    func validate_weblink(variable: String) -> Bool {
        
        if variable.isEmpty {
            alert_text = "Are you sure you want to leave this field empty?"
            return false
        }
        
        else if variable.hasPrefix("http://") || variable.hasPrefix("https://") {
            alert_text = ""
            return true
        }
        else {
            alert_text = "Invalid form. Write the URL as: http://yourwebsite.com"
            return false
        }
    }
    
    func validate_website(variable: String) -> Bool {
        if variable.isEmpty {
            alert_text = "website can't be empty"
            return false
        }
        
        else {
            alert_text = ""
            return true
        }
    }
    
}

struct ButtonRowView2: View {
    var buttonAction: () -> Void
    var icon: String
    var color: Color = shade2

    var body: some View {
        Button(action: buttonAction) {
            Image(systemName: icon)
                .foregroundColor(.white).imageScale(.medium)
                .frame(width: 68, height: 44)
                .background(color)
                .cornerRadius(7)
        }
    }
}

struct NewFormView_Previews: PreviewProvider {
    static var previews: some View {
        NewFormView(
            title: "Example Title",
            variable: .constant("Example"),
            secure: true,
            placeholder: "Enter your text here",
            uuid: .constant(UUID().uuidString)
        )
        .environment(\.colorScheme, .light)
    }
}
