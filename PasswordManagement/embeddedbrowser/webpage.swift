//
//  webpage.swift
//  PasswordManagement
//
//  Created by Alessandra Bontempi on 22/12/23.
//

import SwiftUI
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL
    var username: String
    var password: String
    var oldPassword: String
    var action: ActionType?

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)

        uiView.navigationDelegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, username: username, password: password, oldPassword: oldPassword, action: action)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var username: String
        var password: String
        var oldPassword: String
        var action: ActionType?

        init(_ parent: WebView, username: String, password: String, oldPassword: String, action: ActionType?) {
            self.parent = parent
            self.username = username
            self.password = password
            self.oldPassword = oldPassword
            self.action = action
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // Inject JavaScript based on the action
            switch action {
            case .changePassword:
                // JavaScript code to change the password
                break
            case .deleteAccount:
                // JavaScript code to delete the account
                break
            case .deleteSubscription:
                // JavaScript code to delete the subscription
                break
            default:
                // JavaScript code to login
                let loginScript = """
                document.querySelector('#usernameField').value = '\(username)';
                document.querySelector('#passwordField').value = '\(password)';
                document.querySelector('#loginButton').click();
                """
                webView.evaluateJavaScript(loginScript, completionHandler: nil)
            }
        }
    }
}
