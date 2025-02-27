//
//  PostRowView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI
import Combine

struct PostRow: View {
    @EnvironmentObject var appManager: AppDelegate
    @ObservedObject var viewModel: PostsViewModel
    let post: Post
    @State private var isFavorite: Bool
    private var cancellables = Set<AnyCancellable>()
    
    init(viewModel: PostsViewModel, post: Post) {
        self.viewModel = viewModel
        self.post = post
        self._isFavorite = State(initialValue: CoreDataManager.shared.isFavorite(postID: post.id))
    }
    
    var body: some View {
        ZStack {
            NavigationLink(destination: PostDetailsView(postId: post.id, postTitle: post.title ?? "", postBody: post.body ?? "")) {
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
                            toggleFavorite()
                        }}){
                        Image(isFavorite ? .favFilled : .favUnFilled)
                            .resizable()
                            .aspectRatio(1, contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .foregroundColor(.white)
                    }
                    .buttonStyle(PlainButtonStyle())
                    .padding(.bottom, 5)
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
            if let isFavorite = favorites[post.id] {
                self.isFavorite = isFavorite
            }
        }
    }
    
    private func toggleFavorite() {
        CoreDataManager.shared.updateFavoriteStatus(postID: post.id, isFavorite: !isFavorite)
        sendFavoriteNotification()
    }
    
    private func sendFavoriteNotification() {
        let title = isFavorite ? "Post Favorited" : "Post Unfavorited"
        let body = isFavorite ?
        NotificationMessages.addFavouriteBody(postTitle: post.title ?? "Title").message :
        NotificationMessages.removeFavouriteBody(postTitle: post.title ?? "Body").message
        appManager.sendNotification(title: title, body: body)
    }
}
