//
//  TransactionCD+CoreDataClass.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//
//

import Foundation
import CoreData


public class TransactionCD: NSManagedObject {
    convenience init(transaction: Transaction) {
        self.init()
        self.uuid = transaction.uuid
        self.amount = transaction.amount
        self.category = transaction.category.rawValue
        self.createdAt = transaction.createdAt
        self.type = transaction.type.rawValue
    }
}

extension TransactionCD: DOMAINConvertible {
    func domain() -> Transaction {
        return Transaction(transactionCD: self)
    }
}
