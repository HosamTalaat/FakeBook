//
//  AppDelegate.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import SwiftUI
import Network
import UserNotifications


class AppDelegate: NSObject, ObservableObject, UNUserNotificationCenterDelegate {
    static let shared = AppDelegate()
    
    let monitor = NWPathMonitor()
    @Published var isConnected: Bool = true
    
    private override init() {
        super.init()
        UNUserNotificationCenter.current().delegate = self
    }
    
    func initializeApp() {
        setupNetworkMonitor()
        requestNotificationPermission()
    }
    
     func setupNetworkMonitor() {
        let queue = DispatchQueue.global(qos: .background)
        monitor.start(queue: queue)
        monitor.pathUpdateHandler = { [weak self] path in
            guard let self = self else { return }
            DispatchQueue.main.async {
                let newConnectionStatus = path.status == .satisfied
                
                if newConnectionStatus == self.isConnected {
                    return
                }
                
                self.isConnected = newConnectionStatus
                NotificationCenter.default.post(
                    name: .networkStatusChanged,
                    object: nil,
                    userInfo: ["isConnected": newConnectionStatus]
                )
                
                if newConnectionStatus {
                    self.sendNotification(
                        title: NotificationMessages.internetOnTitle.message,
                        body: NotificationMessages.internetOnBody.message
                    )
                } else {
                    self.showSystemNoInternetAlert()
                }
            }
        }
    }
    
     func requestNotificationPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if granted {
                print("Notification permission granted.")
            } else if let error = error {
                print("Error requesting notification permission: \(error)")
            }
        }
    }
    
     func sendNotification(title: String, body: String) {
        let content = UNMutableNotificationContent()
        content.title = title
        content.body = body
        content.sound = .default
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 1, repeats: false)
        let request = UNNotificationRequest(
            identifier: UUID().uuidString,
            content: content,
            trigger: trigger
        )
        
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Error sending notification: \(error)")
            }
        }
    }
    
    private func showSystemNoInternetAlert() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootViewController = windowScene.windows.first?.rootViewController else {
            return
        }
        
        let alert = UIAlertController(
            title: "Alert!",
            message: "Internet Connection Lost",
            preferredStyle: .alert
        )
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        rootViewController.present(alert, animated: true)
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                              willPresent notification: UNNotification,
                              withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner, .badge, .sound])
    }
}
