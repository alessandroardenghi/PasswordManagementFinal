import Foundation
import UserNotifications

class NotificationManager: ObservableObject {
    
    func ask_permission() {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) {success, error in
            if success {
                print("Access Granted")
                UserDefaults.standard.set(true, forKey: "Notifications")
            }
            else if let error = error {
                print(error.localizedDescription)
            }
        }
    }
    
    func add_notification(id: String, date: Date, title: String, body: String, repeats: Bool) {
        
        var trigger: UNNotificationTrigger?
        var date_components = Calendar.current.dateComponents([.day, .month, .minute], from: date)
        date_components.hour = 12
        trigger = UNCalendarNotificationTrigger(dateMatching: date_components, repeats: repeats)
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = UNNotificationSound.default
        
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error adding notification:", error.localizedDescription)
            } else {
                print("Notification Added")
            }
        }
    }
    
    func remove_notification(withIdentifier id: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [id])
    }
    
    func update_notification(id: String, date: Date, title: String, body: String, repeats: Bool) {
        
        remove_notification(withIdentifier: id)
        add_notification(id: id, date: date, title: title, body: body, repeats: repeats)
    }
    
    func see_pending_notifications() {
        UNUserNotificationCenter.current().getPendingNotificationRequests { requests in
            print("PRINTING SCHEDULED NOTIFICATIONS")
            for request in requests {
                print("Scheduled Notification ID:", request.identifier)
                print("Notification Title:", request.content.title)
                print("Notification Body:", request.content.body)
                print("Notification Scheduled Date:", request.trigger as? UNCalendarNotificationTrigger? as Any)
                print("------")
            }
        }
    }
}
