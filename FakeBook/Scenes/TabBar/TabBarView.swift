//
//  TabBarView.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 27/02/2025.
//


import SwiftUI

struct TabBarView: View {
    @State private var showSplash = true
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 1.0

    init() {
        let tabBarAppearance = UITabBarAppearance()
        tabBarAppearance.configureWithOpaqueBackground()
        tabBarAppearance.backgroundColor = .black
        UITabBar.appearance().standardAppearance = tabBarAppearance
        UITabBar.appearance().scrollEdgeAppearance = tabBarAppearance
        UITabBar.appearance().tintColor = .white
        UITabBar.appearance().unselectedItemTintColor = .gray
    }
    
    var body: some View {
        if showSplash {
            SplashScreen(showSplash: $showSplash)
        } else {
            TabView {
                PostsView()
                    .tabItem {
                        Label("Posts", systemImage: "list.bullet.rectangle")
                    }
                
                FavoritesView()
                    .tabItem {
                        Label("Favorites", systemImage: "heart.fill")
                    }
            }
            .accentColor(.white)
            .background(Color.black)
        }
    }
}

#Preview {
    TabBarView()
}
