import SwiftUI
import WebKit

// this code is not implemented yet, thus it is not inserted with the remaining swift files. An implemented version was used during trials before the introduction of the keychain. However, that code is now obsolete.
// some logic must be modified in order to conneect the text "generate new password" in the New Item View to the bot and the backend system, but it will be done in the nearby future hopefully.

// struct WebView Structure:
    // Bindings to pass data from SwiftUI to WebView
    // Bind URL
    // Bind username
    // Bind password
    // Bind action (like changePassword, deleteAccount, etc.)

    // Function makeUIView(context):
        // Initialize a new web view: WKWebView

    // Function updateUIView(uiView, context):
        // create an URL request and load it in the web view

    // Define Coordinator class:

        // create a coordinator such that we can handle web view navigation and actions
        
            // handle actions when a web page finishes loading
            // switch based on the action type:
                // case changePassword:
                // case deleteAccount:
                // case deleteSubscription:
            
        // Function createRequest(for URL, action):
            // create a URLRequest for communicating with the backend and set method = POST
            // prepare the body with necessary data, which will be sent to the python script: so include username, oldPassword, password (the new password generated), ...
            // convert to JSON and set the URL request

// this was the way we set it up initially, however we need to re-implement it with the keychain logic.
