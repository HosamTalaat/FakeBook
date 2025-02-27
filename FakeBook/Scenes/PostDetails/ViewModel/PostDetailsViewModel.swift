//
//  PostDetailsViewModel.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import Combine

@MainActor
class PostDetailsVM: ObservableObject {
    @Published var comments: [Comment] = []
    @Published var errorMessage: String?
    @Published var isLoading: Bool = false
    @Published var isFavorite: Bool

    private var postId: Int
    private var cancellables = Set<AnyCancellable>()

    init(postId: Int) {
        self.postId = postId
        self.isFavorite = CoreDataManager.shared.isFavorite(postID: postId)
        setupFavoriteSubscription()
        Task {
            await fetchComments()
        }
    }

    func fetchComments() async {
        self.errorMessage = ""
        self.isLoading = true
        do {
            let commentsURL = String(format: EndPoints.Comments, String(postId))
            let fetchedComments: [Comment] = try await APIServices.shared.getData(url: commentsURL)
            DispatchQueue.main.async {
                self.comments = fetchedComments
                self.isLoading = false
            }
        } catch let error as NetworkError {
            DispatchQueue.main.async {
                self.errorMessage = self.handleError(error)
                self.isLoading = false
            }
        } catch {
            DispatchQueue.main.async {
                self.errorMessage = error.localizedDescription
                self.isLoading = false
            }
        }
    }

    func toggleFavorite() {
        isFavorite.toggle() 
        CoreDataManager.shared.updateFavoriteStatus(postID: postId, isFavorite: isFavorite)
    }

    
    private func handleError(_ error: NetworkError) -> String {
        return error.localizedDescription
    }

    private func setupFavoriteSubscription() {
        CoreDataManager.shared.favoriteStatusPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] favorites in
                guard let self = self else { return }
                if let updatedIsFavorite = favorites[self.postId] {
                    self.isFavorite = updatedIsFavorite
                }
            }
            .store(in: &cancellables)
    }
}
