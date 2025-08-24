//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//

import Foundation

struct Transaction: Hashable {
    let uuid: UUID
    let amount: Double
    let category: Category
    let createdAt: Date
    let type: TransactionType
    
    init(transactionCD: TransactionCD) {
        self.uuid = transactionCD.uuid
        self.amount = transactionCD.amount
        self.category = .init(rawValue: transactionCD.category)
        self.createdAt = transactionCD.createdAt
        self.type = .init(rawValue: transactionCD.type)
    }
}

extension Transaction {
    enum Category: String {
        case groceries, taxi,
             electronics, restaurant,
             other
        
        init(rawValue: String) {
            switch rawValue {
            case Self.groceries.rawValue:
                self = .groceries
            case Self.taxi.rawValue:
                self = .taxi
            case Self.electronics.rawValue:
                self = .electronics
            case Self.restaurant.rawValue:
                self = .restaurant
            default:
                self = .other
            }
        }
    }
    
    enum TransactionType: Hashable {
        case deposit, withdrawal
        case undefined(String)
        
        init(rawValue: String) {
            switch rawValue {
            case Self.deposit.rawValue:
                self = .deposit
            case Self.withdrawal.rawValue:
                self = .withdrawal
            default:
                self = .undefined(rawValue)
            }
        }
        
        var rawValue: String {
            switch self {
            case .deposit:
                return "deposit"
            case .withdrawal:
                return "withdrawal"
            case .undefined(let value):
                return value
            }
        }
        
        static func ==(lhs: TransactionType, rhs: TransactionType) -> Bool {
            return lhs.rawValue == rhs.rawValue
        }
        
        func hash(into hasher: inout Hasher) {
            hasher.combine(rawValue)
        }
    }
}
