//
//  NotificationsExtension.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation

extension Notification.Name {
    static let networkStatusChanged = Notification.Name("networkStatusChanged")
    static let postsUpdated = Notification.Name("postsUpdated")
    static let postDataUpdated = Notification.Name("postDataUpdated")
    static let favoriteStatusChanged = Notification.Name("favoriteStatusChanged")

}
