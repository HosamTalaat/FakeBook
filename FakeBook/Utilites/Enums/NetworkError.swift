//
//  NetworkError.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
enum NetworkError: Error {
    case invalidURL
    case decodingFailed
    case noData
    case urlSessionFailed
    case other(Error)
}
