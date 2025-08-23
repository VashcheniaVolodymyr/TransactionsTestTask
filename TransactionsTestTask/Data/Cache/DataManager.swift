//
//  DataManager.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine

final class DataManager: Injectable {
    var exchangeRate: CurrentValueSubject<ExchangeRate?, Never> = .init(nil)
    
    init() {
        
    }
}
