//
//  DetailView.swift
//  PasswordManagement
//
//  Created by Alessandro Ardenghi on 22/12/23.
//

import Foundation
import SwiftUI
import SwiftData

enum ActionType: String {
    case changePassword = "change_password"
    case deleteAccount = "delete_account"
    case deleteSubscription = "delete_subscription"
}

struct DetailView: View {
    @Environment(\.colorScheme) var colorScheme
    @State var value = 0.0
    @State var variable: LoginInfoItem
    @State private var showWebView = false
    @State var extras: Bool = false
    @State private var selectedAction: ActionType?

    var body: some View {
        ScrollView {
            VStack (spacing: 2) {
                Text("Login Info")
                    .bold()
                    .font(.system(size: 30))
                    .padding()

                NewFormView(title: "Website", variable: $variable.website, secure: false, placeholder: "Enter website", uuid: $variable.id)

                NewFormView(title: "Email", variable: $variable.email, secure: false, placeholder: "Enter email", uuid: $variable.id)

                NewFormView(title: "Weblink", variable: $variable.weblink, secure: false, placeholder: "https://yourwebsite.com", uuid: $variable.id)

                NewFormView(title: "Username", variable: $variable.username, secure: false, placeholder: "Enter username", uuid: $variable.id)

                NewFormView(title: "Password", variable: $variable.password, secure: true, placeholder: "Enter password", uuid: $variable.id)

                Text("Subscription")
                    .bold()
                    .padding()

                Picker("Select", selection: $variable.subscription) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)

                if variable.subscription {
                    Text("Select End Date")
                        .bold()
                        .padding()
                    DatePicker("", selection: $variable.subscription_date, displayedComponents: .date)
                        .datePickerStyle(DefaultDatePickerStyle())
                        .padding(.horizontal)
                        .frame(width: 100)

                    Spacer()

                    Button(action: {
                        selectedAction = .deleteSubscription
                        performAction(action: .deleteSubscription)
                    }) {
                        Text("Delete subscription")
                            .frame(width: 250, height: 30)
                            .padding()
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    .sheet(isPresented: $showWebView) {
                        WebView(url: URL(string: variable.weblink)!, username: variable.username, password: variable.password, oldPassword: variable.oldPassword, action: selectedAction)
                    }
                }

                Text("Extras")
                    .bold()
                    .padding()
                Picker("Select", selection: $extras) {
                    Text("Yes").tag(true)
                    Text("No").tag(false)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                .frame(maxWidth: 320)

                if extras {
                    VStack(alignment: .leading) {
                        CheckBoxView(background: .blue, variable: $variable.full_name, text: "Full Name")

                        CheckBoxView(background: .blue, variable: $variable.address, text: "Address")

                        CheckBoxView(background: .blue, variable: $variable.credit_card, text: "Credit Card")

                        CheckBoxView(background: .blue, variable: $variable.date_of_birth, text: "Date of Birth")
                    }
                }

                Button(action: {
                                    selectedAction = .changePassword
                                    performAction(action: .changePassword)
                                }) {
                                    Text("Change Password")
                                        .frame(width: 250, height: 30)
                                        .padding()
                                        .foregroundColor(.white)
                                        .background(Color.blue)
                                        .cornerRadius(10)
                                }
                                .sheet(isPresented: $showWebView) {
                                    WebView(url: URL(string: variable.weblink)!, username: variable.username, password: variable.password, oldPassword: variable.oldPassword, action: selectedAction)
                                }

                Spacer()

                Button(action: {
                    selectedAction = .deleteAccount
                    performAction(action: .deleteAccount)
                }) {
                    Text("Delete account")
                        .frame(width: 250, height: 30)
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.blue)
                        .cornerRadius(10)
                }
                .sheet(isPresented: $showWebView) {
                    WebView(url: URL(string: variable.weblink)!, username: variable.username, password: variable.password, oldPassword: variable.oldPassword, action: selectedAction)
                }
                .padding(20)
            }
        }
    }

    private func performAction(action: ActionType) {
        var parameters = ["username": variable.username,
                          "url": variable.weblink,
                          "action": action.rawValue]
        
        if action == .changePassword {
            parameters["oldPassword"] = variable.oldPassword
            parameters["password"] = variable.password
        } else {
            parameters["password"] = variable.password
        }

        let endpoint: String
        switch action {
        case .changePassword:
            endpoint = "http://127.0.0.1:5000/change_password"
        case .deleteAccount:
            endpoint = "http://127.0.0.1:5000/delete_account"
        case .deleteSubscription:
            endpoint = "http://127.0.0.1:5000/delete_subscription"
        }

        sendPostRequest(url: endpoint, parameters: parameters) { result in
            switch result {
            case .success(let responseStr):
                print("Response: \(responseStr)")
                showWebView = true
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
    }
}

func sendPostRequest(url: String, parameters: [String: Any], completion: @escaping (Result<String, Error>) -> Void) {
    guard let url = URL(string: url) else {
        print("Invalid URL")
        return
    }

    var request = URLRequest(url: url)
    request.httpMethod = "POST"
    request.addValue("application/json", forHTTPHeaderField: "Content-Type")

    do {
        request.httpBody = try JSONSerialization.data(withJSONObject: parameters)
    } catch {
        completion(.failure(error))
        return
    }

    URLSession.shared.dataTask(with: request) { data, response, error in
        if let error = error {
            completion(.failure(error))
            return
        }
        if let data = data, let responseStr = String(data: data, encoding: .utf8) {
            completion(.success(responseStr))
        } else {
            completion(.failure(NSError(domain: "", code: -1, userInfo: nil)))
        }
    }.resume()
}
