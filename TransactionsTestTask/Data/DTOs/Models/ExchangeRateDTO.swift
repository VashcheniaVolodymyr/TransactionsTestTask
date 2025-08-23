//
//  ExchangeRateDTO.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation

struct ExchangeRateDTO: Responsable, DOMAINConvertible {
    let data: [String: [String: Double]]
    
    func dto() -> ExchangeRateDTO {
        return self
    }
    
    func domain() -> ExchangeRate {
        return ExchangeRate(dto: dto())
    }
    
    enum CodingKeys: CodingKey {
        case rates
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        self.data = try container.decode([String: [String: Double]].self)
    }
}
