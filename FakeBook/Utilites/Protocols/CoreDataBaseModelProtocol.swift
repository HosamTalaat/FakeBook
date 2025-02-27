//
//  CoreDataBaseModelProtocol.swift
//  FakeBook
//
//  Created by Hossam Tal3t on 21/02/2025.
//

import Foundation
import CoreData
protocol CoreDataBaseModel {
    static var viewContext: NSManagedObjectContext { get }
    func save() throws
    func delete() throws
}
