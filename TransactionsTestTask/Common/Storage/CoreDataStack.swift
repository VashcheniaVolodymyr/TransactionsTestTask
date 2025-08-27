//
//  CoreDataStack.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 27.08.2025.
//

import CoreData

struct CoreDataStack {
    static var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TransactionsTestTask")
        container.loadPersistentStores { _, error in
            if let error = error {
                fatalError("❌ Failed to load store: \(error)")
            }
        }
        return container
    }()

    static var viewContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }

    static func backgroundContext() -> NSManagedObjectContext {
        persistentContainer.newBackgroundContext()
    }
}
