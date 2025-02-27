//
//  Comments.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//
import Foundation

struct Comment: Codable, Identifiable,Equatable {
    var id: Int { return UUID().hashValue }
    var postId: Int
    var name: String?
    var body: String?
}
