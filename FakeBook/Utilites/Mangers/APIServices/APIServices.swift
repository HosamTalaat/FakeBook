//
//  APIServices.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation

class APIServices{
   static let shared = APIServices()
   func getData<T: Decodable>(url: String) async throws -> T {
      guard let url = URL(string: url) else {
          throw NetworkError.invalidURL
       }
       let (data , response) = try await URLSession.shared.data(from: url)
       guard let response = response as? HTTPURLResponse , response.statusCode == 200 else {
           throw NetworkError.urlSessionFailed
       }
       do {
           let decoder = JSONDecoder()
           return try decoder.decode(T.self, from: data)
       }
       catch {
           throw NetworkError.other(error)
       }
   }
}
