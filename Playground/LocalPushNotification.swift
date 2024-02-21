//
//  LocalPushNotification.swift
//  Playground
//
//  Created by Jason on 2024/2/21.
//

import SwiftUI
import UserNotifications
import CoreLocation

class NotificationManager {
    static let instance = NotificationManager()
    private init() { }
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { success, error in
            if let error = error {
                print("Error: \(error)")
            } else {
                print("success")
            }
        }
    }
    
    func scheduleNotification() {
        let content = UNMutableNotificationContent()
        content.title = "This is my first notification"
        content.subtitle = "This was sooooo easy"
        content.sound = .default
        content.badge = 1
        
        // 3 types of trigger: time, calendar and location
        // 1. time
        // let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5.0, repeats: false)
        // 2. calendar
//        var dateComponents = DateComponents()
//        dateComponents.hour = 17
//        dateComponents.minute = 23
//        dateComponents.weekday = 2
//        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        // 3. location
        let center = CLLocationCoordinate2D(latitude: 37.335400, longitude: -122.009201)
        let region = CLCircularRegion(center: center, radius: 2000.0, identifier: "Headquarters")
        region.notifyOnEntry = true
        region.notifyOnExit = false
        let trigger = UNLocationNotificationTrigger(region: region, repeats: false)
        
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    func cancelNotification() {
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

struct LocalPushNotification: View {
    var body: some View {
        VStack(spacing: 40.0) {
            Button("Request Permission") {
                NotificationManager.instance.requestAuthorization()
            }
            Button("Schedule Notification") {
                NotificationManager.instance.scheduleNotification()
            }
            Button("Cancel Notification") {
                NotificationManager.instance.cancelNotification()
            }
        }
        .onAppear {
            UNUserNotificationCenter.current().setBadgeCount(0)
        }
    }
}

#Preview {
    LocalPushNotification()
}
