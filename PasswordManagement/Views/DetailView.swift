import Foundation
import SwiftUI
import SwiftData

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @Binding var variable: LoginInfoItem
    @Binding var secure_variable: KeychainItem
    @State private var showWebView = false
    @State var extras: Bool = false
    @StateObject var Keychain = KeychainManager()
    @State var show_alert = false
    @State var change: Bool = false
    @StateObject var viewModel = NewItemViewViewModel()
    @Environment(\.presentationMode) var presentationMode
    @State var old_password: String
    @State var old_subscription_date: Date
    @State var old_subscription_choice: Bool
    @StateObject var Notification = NotificationManager()
    
    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("Login Info")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(shade3)
                    .padding()
                
                NewFormView(title: "Website", variable: $secure_variable.website, secure: false, placeholder: "Enter website", uuid: $variable.id, icon: "globe")
                
                NewFormView(title: "Email", variable: $secure_variable.email, secure: false, placeholder: "Enter email", uuid: $variable.id, icon: "envelope" )
                
                NewFormView(title: "Weblink", variable: $secure_variable.weblink, secure: false, placeholder: "https://yourwebsite.com", uuid: $variable.id, icon: "person")
                
                NewFormView(title: "Username", variable: $secure_variable.username, secure: false, placeholder: "Enter username", uuid: $variable.id, icon: "link")
                
                NewFormView(title: "Password", variable: $secure_variable.password, secure: true, placeholder: "Enter password", uuid: $variable.id, icon: "lock")
                
                SubscriptionView(subscription: $secure_variable.subscription, subscription_date: $variable.subscription_date)
                
                ExtrasView(extras: $secure_variable.extras,
                           full_name: $secure_variable.full_name,
                           address: $secure_variable.address,
                           credit_card: $secure_variable.credit_card,
                           date_of_birth: $secure_variable.date_of_birth,
                           shade2: Color(red: 0.53, green: 0.81, blue: 0.92))
                
                LoginButtonView(title: "Save Changes", background: .green) {
                    if !viewModel.validate_element(website: secure_variable.website, 
                                                   username: secure_variable.username,
                                                   email: secure_variable.email,
                                                   password: secure_variable.password) {
                        show_alert = true
                    } else {
                        do {
                            // Updating value in Keychain
                            try Keychain.update(id: variable.id, new_data: JSONEncoder().encode(secure_variable))

                            // If password has changed, update notifications
                            if secure_variable.password != old_password {
                                variable.password_modification_date = Date()
                                Notification.update_notification(id: variable.id + "password", 
                                                                 date: Calendar.current.date(byAdding: .day, value: 90, to: variable.password_modification_date)!,
                                                                 title: "Reminder",
                                                                 body: "Time to change your password for \(secure_variable.website)",
                                                                 repeats: false)
                                
                            }
                            
                            // If subscription date has changed, update notifications
                            if old_subscription_date != variable.subscription_date {
                                Notification.update_notification(id: variable.id + "subscription", 
                                                                 date: variable.subscription_date,
                                                                 title: "Reminder",
                                                                 body: "Subscription to \(secure_variable.website) expires today",
                                                                 repeats: false)
                            }
                            
                            // If subscription was added, add notification
                            if old_subscription_choice != secure_variable.subscription {
                                Notification.add_notification(id: variable.id + "subscription", 
                                                              date: variable.subscription_date,
                                                              title: "Reminder",
                                                              body: "Subscription to \(secure_variable.website) expires today",
                                                              repeats: false)
                            }
                            
                            variable.modification_date = Date()
                            Notification.see_pending_notifications()
                            presentationMode.wrappedValue.dismiss()
                        }
                        catch {
                            print(error)
                        }
                    }
                    
                }
                .alert(isPresented: $show_alert) {
                    Alert(title: Text(viewModel.alert_title),
                          message: Text(viewModel.alert_message),
                          dismissButton: .default(Text("Ok")))
                }
                .padding(20)
            }
            .padding(20)
        }
    }
    
}
