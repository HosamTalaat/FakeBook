//
//  EmptyFavoritesView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct EmptyFavoritesView: View {
    var body: some View {
        VStack {
            AnimatedImage(name: "heart.gif")
                .frame(width: 150*iPhoneXFactor, height: 150*iPhoneXFactor)
        }
        .foregroundStyle(.black)
        .background(Image("background"))
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}

#Preview {
    EmptyFavoritesView()
}
