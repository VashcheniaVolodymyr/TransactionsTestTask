//
//  Balance.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//

import Combine

struct Balance: Hashable, Synchronizable, CoreDataConvertible {
    let value: Double
    
    var syncKeyPath: WritableKeyPath<DataManager, CurrentValueSubject<Balance, Never>> {
        return \DataManager.self.balance
    }
    
    func coreData() -> BalanceCD {
        return BalanceCD(value: value)
    }
}
