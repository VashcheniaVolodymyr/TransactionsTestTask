//
//  ExchangeRateCD+CoreDataProperties.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//
//

import Foundation
import CoreData

extension ExchangeRateCD {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<ExchangeRateCD> {
        return NSFetchRequest<ExchangeRateCD>(entityName: "ExchangeRateCD")
    }

    @NSManaged public var data: Data?
}

extension ExchangeRateCD: Identifiable {
    
}
