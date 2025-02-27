//
//  PostsView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//

import SwiftUI

struct PostsView: View {
    @ObservedObject var viewModel = PostsViewModel()
    @State private var isConnected: Bool = true
    @State private var isRefreshing = false
    @EnvironmentObject var appManager: AppDelegate
    
    var body: some View {
        NavigationView {
            ZStack {
                List {
                    Section {
                        Text("Posts")
                            .customLabelStyle(color: .white, font: Font.custom(Fonts.W700.rawValue, size: 35*iPhoneXFactor))
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading)
                            .listRowInsets(EdgeInsets())
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .accessibilityIdentifier("PostsLabel")
                    }
                    
                    ForEach(viewModel.posts) { post in
                        PostRow(viewModel: viewModel, post: post)
                            .listRowBackground(Color.clear)
                            .listRowSeparator(.hidden)
                            .frame(width: 369 * iPhoneXFactor)
                            .accessibilityIdentifier("PostCell_\(post.id)")
                        
                    }
                }
                .listStyle(.plain)
                .refreshable {
                    isRefreshing = true
                    Task {
                        await viewModel.fetchPosts(refresh: true)
                        isRefreshing = false
                    }
                }
                .overlay(Group {
                    if viewModel.isLoading && !isRefreshing {
                        ProgressView()
                            .scaleEffect(2)
                            .progressViewStyle(CircularProgressViewStyle(tint: .yellow))
                    }
                })
            }
            .foregroundStyle(.black)
            .background(Image("background"))
            .navigationBarHidden(true)
            .onAppear {
                UIRefreshControl.appearance().tintColor = .yellow
                Task {
                    await viewModel.fetchPosts()
                }
            }
            .onDisappear {
                UIRefreshControl.appearance().tintColor = nil
            }
            .onReceive(NotificationCenter.default.publisher(for: .networkStatusChanged)
                .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)) { notification in
                    if let isConnected = notification.userInfo?["isConnected"] as? Bool, isConnected {
                        Task {
                            await viewModel.fetchPosts()
                        }
                    }
                }
        }
        
    }
}


#Preview {
    PostsView()
}
