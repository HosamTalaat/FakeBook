//
//  FavoriteRow.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI
import Combine

struct FavoriteRow: View {
    let post: PostEntity
    @ObservedObject var viewModel: FavoritesVM
    @State private var isFavorite: Bool
    @EnvironmentObject var appManager: AppDelegate
    private var cancellables = Set<AnyCancellable>()
    
    init(post: PostEntity, viewModel: FavoritesVM) {
        self.post = post
        self.viewModel = viewModel
        self._isFavorite = State(initialValue: CoreDataManager.shared.isFavorite(postID: Int(post.id)))
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: PostDetailsView(postId: Int(post.id), postTitle: post.title ?? "", postBody: post.body ?? "")) {
                Rectangle()
                    .fill(Color.clear)
                    .contentShape(Rectangle())
            }
            .opacity(0)
            .buttonStyle(PlainButtonStyle())
            .allowsHitTesting(true)
            
            VStack(alignment: .leading) {
                HStack {
                    VStack(alignment: .leading, spacing: 4) {
                        Text(PostStaticData.title.rawValue)
                            .customLabelStyle(color: .yellow, font: Font.custom(Fonts.W700.rawValue, size: 17 * iPhoneXFactor))
                        Text(post.title ?? "")
                            .customLabelStyle(color: .white, font: Font.custom(Fonts.W400.rawValue, size: 15 * iPhoneXFactor))
                            .lineLimit(nil)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                    Spacer()
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.3)) {
                            removeFavorite()
                        }
                    }) {
                        Image(isFavorite ? .favFilled : .favUnFilled)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.red)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .accessibilityIdentifier("FavoriteButton")

                }
                
                Text(PostStaticData.body.rawValue)
                    .customLabelStyle(color: .yellow, font: Font.custom(Fonts.W700.rawValue, size: 17 * iPhoneXFactor))
                
                Text(post.body ?? "")
                    .customLabelStyle(color: .white, font: Font.custom(Fonts.W400.rawValue, size: 15 * iPhoneXFactor))
                    .lineLimit(nil)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(18)
        }
        .onReceive(CoreDataManager.shared.favoriteStatusPublisher) { favorites in
            if let isFavorite = favorites[Int(post.id)] {
                self.isFavorite = isFavorite
            }
        }
    }
    
    private func removeFavorite() {
        CoreDataManager.shared.updateFavoriteStatus(postID: Int(post.id), isFavorite: false)
        sendRemoveFavoriteNotification()
    }
    
    private func sendRemoveFavoriteNotification() {
            let title = NotificationMessages.removeFavouriteTitle.message
            let body = NotificationMessages.removeFavouriteBody(postTitle: post.title ?? "This post").message
            appManager.sendNotification(title: title, body: body)
        }
}

#Preview {
    //FavoriteRow()
}
