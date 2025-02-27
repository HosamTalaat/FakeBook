//
//  FavoritesView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI

struct FavoritesView: View {
        @ObservedObject var viewModel = FavoritesVM()
        @EnvironmentObject var appManager: AppDelegate
        @State private var contentExceedsScreen = false

        var body: some View {
            NavigationView {
                ZStack {
                    Image("background")
                          .resizable()
                          .edgesIgnoringSafeArea(.all)
                    if viewModel.favoritePosts.isEmpty {
                        EmptyFavoritesView()
                    } else {
                        List {
                            Section {
                                Text("Favorites")
                                    .customLabelStyle(color: .white, font: Font.custom(Fonts.W700.rawValue, size: 35*iPhoneXFactor))
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .padding(.leading)
                                    .listRowInsets(EdgeInsets())
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .accessibilityIdentifier("FavoritesLabel")
                            }

                            ForEach(viewModel.favoritePosts) { post in
                                FavoriteRow(post: post, viewModel: viewModel)
                                    .listRowBackground(Color.clear)
                                    .listRowSeparator(.hidden)
                                    .transition(.slide)
                                    .frame(width: 369 * iPhoneXFactor)
                                    .accessibilityIdentifier("FavoriteCell_\(post.id)")

                            }
                            .onDelete(perform: deleteFavorite)
                        }
                        .listStyle(.plain)
                        .foregroundStyle(.black)
                        .background(Image("background"))
                        .animation(.easeInOut(duration: 0.3), value: viewModel.favoritePosts)
                    }
                }
                .navigationBarHidden(true)
                .onAppear {
                    viewModel.fetchFavorites()
                }
                

            }

        }

        func deleteFavorite(at offsets: IndexSet) {
            withAnimation(.easeInOut(duration: 0.3)) {
                for index in offsets {
                    let post = viewModel.favoritePosts[index]
                    CoreDataManager.shared.updateFavoriteStatus(postID: Int(post.id), isFavorite: false)
                    sendRemoveFavoriteNotification(post: post)
                }
                viewModel.fetchFavorites()
            }
        }

        func sendRemoveFavoriteNotification(post: PostEntity) {
            let title = NotificationMessages.removeFavouriteTitle.message
            let body = NotificationMessages.removeFavouriteBody(postTitle: post.title ?? "This post").message
            appManager.sendNotification(title: title, body: body)
        }
    }

#Preview {
    FavoritesView()
}
