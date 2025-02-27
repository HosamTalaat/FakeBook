//
//  FavoritesViewModel.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.


import Foundation
import Combine

class FavoritesVM: ObservableObject {
    @Published var favoritePosts: [PostEntity] = []
    private var cancellables = Set<AnyCancellable>()

    init() {
        fetchFavorites()
        setupFavoriteSubscription()
    }

    func fetchFavorites() {
        favoritePosts = CoreDataManager.shared.getFavoritePosts()
    }

    private func setupFavoriteSubscription() {
        CoreDataManager.shared.favoriteStatusPublisher
            .sink { [weak self] _ in
                self?.fetchFavorites()
            }
            .store(in: &cancellables)
    }
}
