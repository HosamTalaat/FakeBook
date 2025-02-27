//
//  CoreDataManger.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import CoreData
import Combine


struct CoreDataManager {
    static let shared = CoreDataManager()
    
    let container: NSPersistentContainer
    private let favoriteStatusSubject = CurrentValueSubject<[Int: Bool], Never>([:])
    var favoriteStatusPublisher: AnyPublisher<[Int: Bool], Never> {
        favoriteStatusSubject.eraseToAnyPublisher()
    }

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "CoreDataModel")
        if inMemory {
            container.persistentStoreDescriptions.first?.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { storeDescription, error in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
    }

    var context: NSManagedObjectContext {
        container.viewContext
    }

    func saveContext() {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            print("Failed to save context: \(error.localizedDescription)")
        }
    }

    func savePost(_ post: Post, index: Int) {
        if let existingPost = PostEntity.fetchPost(byID: post.id) {
            existingPost.orderIndex = Int64(index)
            saveContext()
            return
        }

        let newPost = PostEntity(context: context)
        newPost.id = Int64(post.id)
        newPost.title = post.title ?? ""
        newPost.body = post.body ?? ""
        newPost.orderIndex = Int64(index)
        newPost.isFavorite = false
        saveContext()
    }

    func getAllPosts() -> [Post] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]
        do {
            let postEntities = try context.fetch(request)
            var posts = [Post]()
            for entity in postEntities {
                if !posts.contains(where: { $0.id == Int(entity.id) }) {
                    posts.append(Post(id: Int(entity.id), title: entity.title ?? "", body: entity.body ?? ""))
                }
            }
            return posts
        } catch {
            print("Failed to fetch posts: \(error.localizedDescription)")
            return []
        }
    }

    func updateFavoriteStatus(postID: Int, isFavorite: Bool) {
        guard let post = PostEntity.fetchPost(byID: postID) else { return }
        post.isFavorite = isFavorite
        saveContext()
        var currentFavorites = favoriteStatusSubject.value
        currentFavorites[postID] = isFavorite
        favoriteStatusSubject.send(currentFavorites)
    }

    func getFavoritePosts() -> [PostEntity] {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "isFavorite == %@", NSNumber(value: true))
        request.sortDescriptors = [NSSortDescriptor(key: "orderIndex", ascending: true)]
        return (try? context.fetch(request)) ?? []
    }

    func isFavorite(postID: Int) -> Bool {
        return PostEntity.fetchPost(byID: postID)?.isFavorite ?? false
    }
}
