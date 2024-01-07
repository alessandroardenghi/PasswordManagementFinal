import SwiftUI
import SwiftData

@main
struct PasswordManagementApp: App {

    var body: some Scene {
        WindowGroup {
            ContentView()
        }
        .modelContainer(for: LoginInfoItem.self)
    }
}
