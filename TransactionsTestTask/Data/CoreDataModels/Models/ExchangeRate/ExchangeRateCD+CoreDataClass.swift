//
//  ExchangeRateCD+CoreDataClass.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//
//

import Foundation
import CoreData

public class ExchangeRateCD: NSManagedObject {
    convenience init(dto: ExchangeRateDTO) {
        self.init(context: CoreDataStack.viewContext)
        self.data = try? JSONEncoder().encode(dto)
    }
}

extension ExchangeRateCD: DOMAINConvertible, UniqueEntity {
    func domain() -> ExchangeRate? {
        return self.data?.decoded(as: ExchangeRateDTO.self)?
            .domain()
    }
}
