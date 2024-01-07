import SwiftUI
import WebKit

// this code is not complete yet, thus it is not inserted with the remaining swift files to avoid bugs/crashes. It was used during the trials, before the implementation of the keychain.
// some logic must be modified in order to conneect the text "generate new password" in the New Item View to the bot and the backend system, but it will be done in the nearby future hopefully.

struct WebView: UIViewRepresentable {
    @Binding var url: URL
    @Binding var username: String
    @Binding var password: String
    @Binding var action: ActionType?
    @Binding var keychainItem: KeychainItem

    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }

    func updateUIView(_ uiView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        uiView.load(request)
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView

        init(_ parent: WebView) {
            self.parent = parent
        }

        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            guard let action = parent.action else { return }
            switch action {
            case .changePassword:
                let request = createRequest(for: parent.url, action: action)
                webView.load(request)
            // the actions of deleting the account and subscription have not been implemented yet
            case .deleteAccount:
                break
            case .deleteSubscription:
                break
            default:
                break
            }
        }

        private func createRequest(for url: URL, action: ActionType) -> URLRequest {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let body: [String: Any] = [
                "username": parent.keychainItem.username,
                "oldPassword": parent.password,
                "password": parent.keychainItem.password,
                "url": parent.keychainItem.weblink
            ]
            request.httpBody = try? JSONSerialization.data(withJSONObject: body)
            return request
        }
    }
}

enum ActionType {
    case changePassword
    case deleteAccount
    case deleteSubscription
}
