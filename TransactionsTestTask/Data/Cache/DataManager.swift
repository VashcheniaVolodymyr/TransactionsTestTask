//
//  DataManager.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine

protocol DataManagerProtocol {
    var exchangeRate: CurrentValueSubject<ExchangeRate?, Never>  { get set }
    var balance: CurrentValueSubject<Balance, Never>  { get set }
}

final class DataManager: Injectable {
    // MARK: Public
    var exchangeRate: CurrentValueSubject<ExchangeRate?, Never> = .init(nil)
    var balance: CurrentValueSubject<Balance, Never> = .init(.init(value: 0))
    
    // MARK: Init
    init() {}
}

extension DataManager: DataManagerProtocol { }
