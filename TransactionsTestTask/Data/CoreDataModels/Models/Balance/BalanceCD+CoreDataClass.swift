//
//  BalanceCD+CoreDataClass.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//
//

import Foundation
import CoreData


public class BalanceCD: NSManagedObject {
    convenience init(value: Double) {
        self.init(context: CoreDataStack.viewContext)
        self.value = value
    }
}

extension BalanceCD: DOMAINConvertible, UniqueEntity {
    func domain() -> Balance {
        return Balance(value: self.value)
    }
}
