//
//  ExchangeRate.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine

struct ExchangeRate: Hashable, Synchronizable {
    let rates: [String: [String: Double]]
    
    init(dto: ExchangeRateDTO) {
        self.rates = dto.data
    }
    
    func price(for ids: Currency, vs: Currency) -> Double? {
        return rates[ids.rawValue]?[vs.rawValue]
    }
    
    var syncKeyPath: WritableKeyPath<DataManager, CurrentValueSubject<ExchangeRate?, Never>> {
        return \DataManager.self.exchangeRate
    }
}
