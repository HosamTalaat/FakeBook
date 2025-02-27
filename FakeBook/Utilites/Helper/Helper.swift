//
//  Helper.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import UIKit

public var screenWidth: CGFloat { get { return UIScreen.main.bounds.size.width } }
public var screenHeight: CGFloat { get { return UIScreen.main.bounds.size.height } }
public var iPhoneXFactor: CGFloat { get {return ((screenWidth * 1.00) / 393.00)} }

func handleError(_ error: NetworkError) -> String {
   switch error {
   case .invalidURL:
       return "The URL provided is invalid."
   case .decodingFailed:
       return "Failed to decode the response."
   case .noData:
       return "No data received from the server."
   case .urlSessionFailed:
       return "Network request failed."
   case .other(let err):
       return err.localizedDescription
   }
}
