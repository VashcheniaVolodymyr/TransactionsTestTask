//
//  Balance.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//

import Combine

struct Balance: Hashable, Synchronizable, CoreDataConvertible {
    let value: Double
    
    var syncKeyPath: WritableKeyPath<DataManager, CurrentValueSubject<Atomic<Balance>, Never>> {
        return \DataManager.self.balance
    }
    
    func coreData() -> BalanceCD {
        return BalanceCD(value: value)
    }
    
    static let empty: Balance = .init(value: 0)
}

extension Balance: AtomicData { }
