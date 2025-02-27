//
//  Main.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI

@main
struct FakeBookApp: App {
    @StateObject private var appManager = AppDelegate.shared
    
    var body: some Scene {
        WindowGroup {
            TabBarView()
                .environmentObject(appManager)
                .onAppear{
                    appManager.requestNotificationPermission()
                    appManager.setupNetworkMonitor()
                }
        }
    }
}



