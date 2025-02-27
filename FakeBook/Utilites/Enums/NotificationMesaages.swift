//
//  NotificationMesaages.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import Foundation

enum NotificationMessages {
    case addFavouriteTitle
    case addFavouriteBody(postTitle: String)
    case removeFavouriteTitle
    case removeFavouriteBody(postTitle: String)
    case internetOnTitle
    case internetOnBody

    var message: String {
        switch self {
        case .addFavouriteTitle:
            return "Post Added to Favorites"
        case .addFavouriteBody(let postTitle):
            return "You have added \(postTitle) to your favorites."
        case .removeFavouriteTitle:
            return "Post Removed from Favorites"
        case .removeFavouriteBody(let postTitle):
            return "You have removed \(postTitle) from your favorites."
        case .internetOnTitle:
            return "Internet Restored"
        case .internetOnBody:
            return "Your posts have been synced."
        }
    }
}
