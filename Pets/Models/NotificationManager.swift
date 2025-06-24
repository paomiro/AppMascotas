import Foundation
import UserNotifications
import SwiftUI

class NotificationManager: ObservableObject {
    static let shared = NotificationManager()
    
    private init() {}
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted")
            } else if let error = error {
                print("Notification permission error: \(error)")
            }
        }
    }
    
    func scheduleVaccinationReminder(for vaccination: Vaccination, pet: Pet) {
        let content = UNMutableNotificationContent()
        content.title = "Recordatorio de Vacuna"
        content.body = "\(pet.name) necesita la vacuna \(vaccination.name) en \(vaccination.clinic)"
        content.sound = .default
        
        // Schedule for the due date
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day], from: vaccination.nextDueDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "vaccination-\(vaccination.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func scheduleEventReminder(for event: Event, pet: Pet) {
        let content = UNMutableNotificationContent()
        content.title = "Recordatorio de Evento"
        content.body = "\(event.title) para \(pet.name) - \(event.location)"
        content.sound = .default
        
        // Schedule for 1 hour before the event
        let reminderDate = Calendar.current.date(byAdding: .hour, value: -1, to: event.date) ?? event.date
        let trigger = UNCalendarNotificationTrigger(
            dateMatching: Calendar.current.dateComponents([.year, .month, .day, .hour, .minute], from: reminderDate),
            repeats: false
        )
        
        let request = UNNotificationRequest(
            identifier: "event-\(event.id)",
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification(with identifier: String) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: [identifier])
    }
    
    func cancelAllNotifications() {
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
} 