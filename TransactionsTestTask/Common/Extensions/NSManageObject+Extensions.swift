//
//  NSManageObject+Extensions.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//

import CoreData
import Foundation

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

extension NSManagedObject {
    @discardableResult
    func save(context: NSManagedObjectContext = CoreDataStack.viewContext) -> Result<Void, AppError> {
        guard context.hasChanges else {
            return .failure(.coreDataError(.trySaveWhenHasNotChanges))
        }
        do {
            try context.save()
            return .success(())
        } catch {
            return .failure(.coreDataError(.undefined(error)))
        }
    }

    func fetchAll<T: NSManagedObject>(
        _ type: T.Type,
        context: NSManagedObjectContext = CoreDataStack.viewContext,
        sortDescriptors: [NSSortDescriptor]? = nil,
        predicate: NSPredicate? = nil,
        limit: Int? = nil
    ) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
        request.sortDescriptors = sortDescriptors
        request.predicate = predicate
        if let limit = limit { request.fetchLimit = limit }

        do {
            return try context.fetch(request)
        } catch {
            print("❌ Core Data fetch error: \(error)")
            return []
        }
    }

    func delete(context: NSManagedObjectContext = CoreDataStack.viewContext) {
        context.delete(self)
        save(context: context)
    }

    func deleteAll<T: NSManagedObject>(
        _ type: T.Type,
        context: NSManagedObjectContext = CoreDataStack.viewContext
    ) {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: String(describing: type))
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
            save(context: context)
        } catch {
            print("❌ Core Data batch delete error: \(error)")
        }
    }

    @discardableResult
    func saveUnique(context: NSManagedObjectContext = CoreDataStack.viewContext) -> Result<Void, AppError> {
        let entityName = String(describing: type(of: self))
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try context.execute(deleteRequest)
        } catch {
            return .failure(.coreDataError(.undefined(error)))
        }

        if self.managedObjectContext == nil {
            context.insert(self)
        }

        return save(context: context)
    }
}
