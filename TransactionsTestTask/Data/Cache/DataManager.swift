//
//  DataManager.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine

protocol DataManagerProtocol {
    var exchangeRate: CurrentValueSubject<ExchangeRate?, Never>  { get set }
    var balance: CurrentValueSubject<Atomic<Balance>, Never>  { get set }
}

final class DataManager: Injectable {
    // MARK: Public
    var exchangeRate: CurrentValueSubject<ExchangeRate?, Never> = .init(nil)
    var balance: CurrentValueSubject<Atomic<Balance>, Never> = .init(.init(value: .empty))
    
    // MARK: Init
    init() {}
}

extension DataManager: DataManagerProtocol { }
