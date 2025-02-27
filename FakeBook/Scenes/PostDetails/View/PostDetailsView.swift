//
//  PostDetailsView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI

import SwiftUI

struct PostDetailsView: View {
    @StateObject var viewModel: PostDetailsVM
    @State private var isFavorite: Bool
    let postTitle: String
    let postBody: String
    @EnvironmentObject var appManager: AppDelegate
    @Environment(\.presentationMode) var presentationMode
    @State private var contentExceedsScreen = false

    init(postId: Int, postTitle: String, postBody: String) {
        _viewModel = StateObject(wrappedValue: PostDetailsVM(postId: postId))
        self.postTitle = postTitle
        self.postBody = postBody
        self._isFavorite = State(initialValue: CoreDataManager.shared.isFavorite(postID: postId))
    }

    var body: some View {
        ZStack {
            GeometryReader { geometry in
                ScrollView {
                    VStack(alignment: .leading) {
                        Button(action: {
                            presentationMode.wrappedValue.dismiss()
                        }) {
                            HStack {
                                Image(.backArrow)
                                    .foregroundColor(.white)
                                Text("Post Details")
                                    .customLabelStyle(color: .white, font: Font.custom(Fonts.W400.rawValue, size: 15 * iPhoneXFactor))
                            }
                        }
                        Spacer()

                        VStack(alignment: .leading) {
                            HStack(spacing: 10) {
                                VStack(alignment: .leading) {
                                    Text("\(PostStaticData.title.rawValue)")
                                        .customLabelStyle(color: .yellow, font: Font.custom(Fonts.W700.rawValue, size: 17 * iPhoneXFactor))
                                    Text(postTitle)
                                        .customLabelStyle(color: .white, font: Font.custom(Fonts.W400.rawValue, size: 15 * iPhoneXFactor))
                                }
                                Spacer()
                                Button(action: {
                                    withAnimation(.easeInOut(duration: 0.3)) {
                                        viewModel.toggleFavorite()
                                        sendFavoriteNotification()
                                    }
                                }) {
                                    Image(viewModel.isFavorite ? .favFilled : .favUnFilled)
                                        .resizable()
                                        .aspectRatio(1, contentMode: .fit)
                                        .frame(width: 35, height: 35)
                                        .foregroundColor(.white)
                                }
                                .buttonStyle(PlainButtonStyle())

                            }

                            Text("\(PostStaticData.body.rawValue)")
                                .customLabelStyle(color: .yellow, font: Font.custom(Fonts.W700.rawValue, size: 17 * iPhoneXFactor))
                            Text(postBody)
                                .customLabelStyle(color: .white, font: Font.custom(Fonts.W400.rawValue, size: 15 * iPhoneXFactor))
                        }
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.gray.opacity(0.2))
                                .shadow(radius: 5)
                                .frame(width: 369 * iPhoneXFactor)
                        )

                        Text("Comments")
                            .customLabelStyle(color: .white, font: Font.custom(Fonts.W700.rawValue, size: 20 * iPhoneXFactor))
                            .padding(.bottom)

                        if viewModel.isLoading {
                            ProgressView()
                                .scaleEffect(2)
                                .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                        } else if viewModel.comments.isEmpty {
                            EmptyCommentView()
                        } else {
                            ForEach(viewModel.comments) { comment in
                                CommentRow(comment: comment)
                                    .padding(.bottom, 5)
                            }
                        }
                    }
                    .padding()
                    .background(GeometryReader { contentGeometry in
                        Color.clear
                            .onAppear {
                                let contentHeight = contentGeometry.size.height
                                let screenHeight = geometry.size.height
                                contentExceedsScreen = contentHeight > screenHeight
                            }
                            .onGeometryChange(for: Bool.self, of: { proxy in
                                proxy.size.height > geometry.size.height
                            }, action: { newValue in
                                contentExceedsScreen = newValue
                            })
                    })
                }
                .scrollDisabled(!contentExceedsScreen)
            }
            .foregroundStyle(.black)
            .background(Image("background"))
            .navigationBarHidden(true)
            .onReceive(NotificationCenter.default.publisher(for: .networkStatusChanged)
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)) { notification in
                    if let isConnected = notification.userInfo?["isConnected"] as? Bool, isConnected {
                        Task {
                            await viewModel.fetchComments()
                        }
                    }
                }
                .background(Image("background"))
        }
    }

    private func sendFavoriteNotification() {
        let title = isFavorite ? "Post Favorited" : "Post Unfavorited"
        let body = isFavorite ?
            NotificationMessages.addFavouriteBody(postTitle: postTitle).message :
            NotificationMessages.removeFavouriteBody(postTitle: postBody).message
        appManager.sendNotification(title: title, body: body)
    }
}
