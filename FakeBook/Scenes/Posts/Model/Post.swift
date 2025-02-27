//
//  Post.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation

struct Post: Codable, Identifiable {
    var id: Int
    var title: String?
    var body: String?
}
