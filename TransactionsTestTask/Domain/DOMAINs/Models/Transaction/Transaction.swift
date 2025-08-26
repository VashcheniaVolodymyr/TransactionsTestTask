//
//  Transaction.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//

import Foundation
import Combine
import UIKit

struct Transaction: Hashable, CoreDataConvertible {
    let uuid: UUID
    let amount: Double
    let category: Category?
    let createdAt: Date
    let type: TransactionType
    
    init(amount: Double, category: Category?, createdAt: Date, type: TransactionType) {
        self.uuid = UUID()
        self.amount = amount
        self.category = category
        self.createdAt = createdAt
        self.type = type
    }
    
    init(transactionCD: TransactionCD) {
        self.uuid = transactionCD.uuid
        self.amount = transactionCD.amount
        
        if let category = transactionCD.category {
            self.category = .init(rawValue: category)
        } else {
            self.category = nil
        }
        
        self.createdAt = transactionCD.createdAt
        self.type = .init(rawValue: transactionCD.type)
    }
    
    func coreData() -> TransactionCD {
        return TransactionCD(transaction: self)
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

        var icon: UIImage {
            switch self {
            case .groceries:
                return UIImage(systemName: "square.stack.3d.up") ?? UIImage.init()
            case .taxi:
                return UIImage(systemName: "car.fill") ?? UIImage.init()
            case .electronics:
                return UIImage(systemName: "laptopcomputer.and.iphone") ?? UIImage.init()
            case .restaurant:
                return UIImage(systemName: "fork.knife") ?? UIImage.init()
            case .other:
                return UIImage(systemName: "line.3.horizontal.circle") ?? UIImage.init()
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
