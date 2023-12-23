//
//  webpage.swift
//  PasswordManagement
//
//  Created by Alessandra Bontempi on 22/12/23.
//

import SwiftUI
import Foundation
import WebKit

struct WebView: UIViewRepresentable {
    var url: URL

    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }
}
