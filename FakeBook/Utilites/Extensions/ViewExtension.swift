//
//  UIViewControllerExtension.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import SwiftUI

extension View {
    func customLabelStyle(color: Color, font: Font) -> some View {
        self
            .foregroundColor(color)
            .font(font)
    }
}

