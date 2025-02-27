//
//  EmptyCommentView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct EmptyCommentView: View {
    var body: some View {
        VStack {
            AnimatedImage(name: "emptyComment.gif")
                .frame(width: 150*iPhoneXFactor, height: 150*iPhoneXFactor)
            Text(EmptyStrings.noCommentInternetTitle.rawValue)
                .customLabelStyle(color: .yellow, font: Font.custom(Fonts.W700.rawValue, size: 20*iPhoneXFactor))
            Text(EmptyStrings.noCommentInternetMessage.rawValue)
                .customLabelStyle(color: .white, font: Font.custom(Fonts.W400.rawValue, size: 18*iPhoneXFactor))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
                .multilineTextAlignment(.center)
    }
}

#Preview {
    EmptyCommentView()
}
