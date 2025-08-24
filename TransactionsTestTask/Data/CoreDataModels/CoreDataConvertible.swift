//
//  CoreDataConvertible.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import CoreData

protocol CoreDataConvertible {
    associatedtype CORE: NSManagedObject
    func coreData() -> CORE
}
