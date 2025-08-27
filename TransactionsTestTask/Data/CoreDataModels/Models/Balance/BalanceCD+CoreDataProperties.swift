//
//  BalanceCD+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//
//

import Foundation
import CoreData

extension BalanceCD {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<BalanceCD> {
        return NSFetchRequest<BalanceCD>(entityName: "BalanceCD")
    }

    @NSManaged public var value: Double
}

extension BalanceCD : Identifiable { }
