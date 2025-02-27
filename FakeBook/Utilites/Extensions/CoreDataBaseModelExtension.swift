//
//  CoreDataBaseModelExtension.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import CoreData

extension CoreDataBaseModel where Self: NSManagedObject {
    
    static var viewContext: NSManagedObjectContext {
        CoreDataManager.shared.context
    }

    func save() throws {
        try Self.viewContext.save()
    }

    func delete() throws {
        Self.viewContext.delete(self)
        try save()
    }
}
