import Foundation
import SwiftUI
import SwiftData

let shade1 = Color(red: 0.68, green: 0.85, blue: 0.9)
let shade2 = Color(red: 0.53, green: 0.81, blue: 0.92)
let shade3 = Color(red: 0.0, green: 0.5, blue: 1.0)
let shade4 = Color(red: 0.0, green: 0.0, blue: 0.75)
let shade5 = Color(red: 0.1, green: 0.1, blue: 0.44)

struct TutorialView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @Binding var tutorial_not_seen: Bool
    @Environment(\.presentationMode) var presentationMode
    
    @State var website = "Instagram"
    @State var username = "@JohnDoe"
    @State var email = "johndoe@gmail.com"
    @State var password = "password"
    @State var weblink = "https://instagram.com"
    @State var extras = true
    @State var subscription = true
    @State var subscription_date = Date()
    @State var full_name = true
    @State var date_of_birth = false
    @State var credit_card = false
    @State var address = true

    var body: some View {
        ScrollView {
            VStack (spacing: 2){
                Text("TUTORIAL").font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundColor(shade3)
                    .padding()
                LockedFormView(title: "Website", icon: "globe", variable: $website, secure: false, placeholder: "Instagram")
                LockedFormView(title: "Email", icon: "envelope", variable: $email, secure: false, placeholder: "johndoe@gmail.com")
                LockedFormView(title: "Username", icon: "person", variable: $username, secure: false, placeholder: "@JohnDoe")
                LockedFormView(title: "Weblink", icon: "link", variable: $weblink, secure: false, placeholder: "https://instagram.com")
                LockedFormView(title: "Password", icon: "lock", variable: $password, secure: true, placeholder: "••••••••")

                Spacer()
                
                SubscriptionView(subscription: $subscription, subscription_date: $subscription_date)
                
                ExtrasView(extras: $extras, full_name: $full_name, address: $address, credit_card: $credit_card,
                           date_of_birth: $date_of_birth, shade2: shade2)
                
                LoginButtonView(title: "Got it!", background: shade3) {
                    tutorial_not_seen = false
                    UserDefaults.standard.set(true, forKey: "TUTORIAL")
                }
                
                
                .padding(20)
            }
            
        }
        
    }
}

struct SubscriptionView: View {
    @Binding var subscription: Bool
    @Binding var subscription_date: Date
    let icon: String = "creditcard"

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(shade2)
                    .padding(.leading)
                Text("Subscription")
                    .font(.headline)
                    .foregroundColor(shade2)
            }
            .padding([.leading, .trailing])
            
            Picker("Select", selection: $subscription) {
                Text("Yes").tag(true)
                Text("No").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing])
            .frame(width: 350, alignment: .center)
            .padding(.bottom, 15)
            
            if subscription {
                    
                    DatePicker("Subscription End Date", selection: $subscription_date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding([.leading, .trailing])
                        .font(.subheadline)
                        .frame(width: 350, alignment: .leading)
            }
            
            Text("Select if you have an active subscription")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading)
                .frame(width: 350, alignment: .leading)
        }
        .padding()
        .frame(width: 350, alignment: .center)
    }
}

struct ExtrasView: View {
    @Binding var extras: Bool
    @Binding var full_name: Bool
    @Binding var address: Bool
    @Binding var credit_card: Bool
    @Binding var date_of_birth: Bool
    let icon: String = "list.bullet"
    let shade2: Color

    var body: some View {
        VStack(alignment: .leading) {
            Label {
                Text("Extras")
                    .font(.headline)
                    .padding(.top)
            } icon: {
                Image(systemName: icon)
            }
            .foregroundColor(shade2)
            .padding([.leading, .trailing])
            .padding(.leading)
            
            Picker("Select", selection: $extras) {
                Text("Yes").tag(true)
                Text("No").tag(false)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding([.leading, .trailing])
            .frame(width: 350)
            .padding(.bottom, 15)
            
            if extras {
                VStack(alignment: .leading) {
                    BoxListView(isChecked: $full_name, label: "Full Name")
                    BoxListView(isChecked: $address, label: "Address")
                    BoxListView(isChecked: $credit_card, label: "Credit Card")
                    BoxListView(isChecked: $date_of_birth, label: "Date of Birth")
                }
                .padding([.leading, .trailing])
                .frame(width: 350, alignment: .leading)
                .padding(.bottom, 15)
            }
            
            Text("Select any extra info")
                .font(.caption)
                .foregroundColor(.gray)
                .padding(.leading)
                .frame(width: 350, alignment: .leading)
        }
        .frame(width: 350, alignment: .center)
    }
}

struct BoxListView: View {
    @Binding var isChecked: Bool
    var label: String
    var color: Color = shade2
    
    var body: some View {
        Button(action: { isChecked.toggle() }) {
            HStack {
                Image(systemName: isChecked ? "checkmark.square.fill" : "square")
                    .foregroundColor(isChecked ? color : Color.secondary)
                    .font(.headline)
                Text(label)
                    .foregroundColor(.primary)
            }
            .padding(3)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: LoginInfoItem.self, configurations: config)

    return TutorialView(tutorial_not_seen: Binding(get: {return true}, set: {_ in}))
            .modelContainer(container)
}

