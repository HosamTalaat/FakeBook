//
//  PostEntityExtension.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import CoreData

extension PostEntity: CoreDataBaseModel {
    
    static var all: NSFetchRequest<PostEntity> {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.sortDescriptors = []
        return request
    }
    
    static func fetchPost(byID id: Int) -> PostEntity? {
        let request: NSFetchRequest<PostEntity> = PostEntity.fetchRequest()
        request.predicate = NSPredicate(format: "id == %d", id)
        return try? viewContext.fetch(request).first
    }
}
