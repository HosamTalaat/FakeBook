//
//  CommentRow.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI

struct CommentRow: View {
        let comment: Comment

        var body: some View {
            VStack(alignment: .leading) {
                HStack{
                    Image(.userPlaceholder)
                        .resizable()
                        .frame(width: 25*iPhoneXFactor,height: 25*iPhoneXFactor)
                    Text(comment.name ?? "Unknown User")
                        .customLabelStyle(color: .yellow, font: Font.custom(Fonts.W400.rawValue, size: 14*iPhoneXFactor))
                }
                Text(comment.body ?? "No comment")
                    .customLabelStyle(color: .white, font: Font.custom(Fonts.W400.rawValue, size: 16*iPhoneXFactor))
            }
            .padding()
            .background(Image(.blurBackGround).resizable().aspectRatio(contentMode: .fill))
            .cornerRadius(18)
        }
    }

