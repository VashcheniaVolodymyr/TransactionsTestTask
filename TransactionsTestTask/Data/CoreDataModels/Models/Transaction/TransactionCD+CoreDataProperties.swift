//
//  TransactionCD+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//
//

import Foundation
import CoreData

extension TransactionCD {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<TransactionCD> {
        return NSFetchRequest<TransactionCD>(entityName: "TransactionCD")
    }

    @NSManaged public var createdAt: Date
    @NSManaged public var amount: Double
    @NSManaged public var category: String?
    @NSManaged public var uuid: UUID
    @NSManaged public var type: String

}

extension TransactionCD: Identifiable { }
