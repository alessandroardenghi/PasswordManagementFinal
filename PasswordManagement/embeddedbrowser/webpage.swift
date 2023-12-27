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

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)

        uiView.navigationDelegate = context.coordinator
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self, username: username, password: password)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        var username: String
        var password: String

        init(_ parent: WebView, username: String, password: String) {
            self.parent = parent
            self.username = username
            self.password = password
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            // fill in credentials
            let fillCredentials = "document.getElementById('loginForm').querySelector('[name=username]').value='\(username)';document.getElementById('loginForm').querySelector('[name=password]').value='\(password)';"
            
            // the user will have to manually take care of pop ups since selectors are different from page to page, and one XPATH wouldn't work for all pages
            webView.evaluateJavaScript(fillCredentials, completionHandler: nil)
        }
    }
}
