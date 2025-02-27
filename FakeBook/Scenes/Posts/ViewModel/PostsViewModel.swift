//
//  PostsViewModel.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import Combine

@MainActor
class PostsViewModel: ObservableObject {
    @Published var posts: [Post] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    private var cancellables = Set<AnyCancellable>()

    init() {
        setupFavoriteSubscription()
    }

    func fetchPosts(refresh: Bool = false) async {
        errorMessage = nil
        if !refresh {
            isLoading = true
        }

        do {
            let fetchedPosts: [Post] = try await APIServices.shared.getData(url: EndPoints.Posts)
            posts = fetchedPosts
            await savePostsToCoreData(posts: fetchedPosts)
        } catch {
            errorMessage = handleError(error)
            posts = CoreDataManager.shared.getAllPosts()
        }

        isLoading = false
    }

    private func savePostsToCoreData(posts: [Post]) async {
        for (index, post) in posts.enumerated() {
            CoreDataManager.shared.savePost(post, index: index)
        }
    }

    private func handleError(_ error: Error) -> String {
        return (error as? NetworkError)?.localizedDescription ?? "Unexpected error occurred."
    }

    private func setupFavoriteSubscription() {
        CoreDataManager.shared.favoriteStatusPublisher
            .sink { [weak self] _ in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
