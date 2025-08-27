//
//  AnalyticsEvent.swift
//  TransactionsTestTask
//
//

import Foundation

enum AnalyticsEventName: Equatable {
    case rateUpdated
    case deposit
    case widrawal
    case tapToDeposit
    case tapToAddTransaction
    case custom(String)
    
    var rawValue: String {
        switch self {
        case .deposit:
            return "deposit"
        case .widrawal:
            return "withdrawal"
        case .tapToDeposit:
            return "tap_to_deposit"
        case .tapToAddTransaction:
            return "tap_to_add_transaction"
        case .rateUpdated:
            return "rate_updated"
        case .custom(let rawValue):
            return rawValue
        }
    }
    
    static func ==(lhs: AnalyticsEventName, rhs: AnalyticsEventName) -> Bool {
        return lhs.rawValue == rhs.rawValue
    }
}

struct AnalyticsEvent {
    let name: AnalyticsEventName
    let parameters: [String: String]
    let date: Date
    
    init(
        name: AnalyticsEventName,
        parameters: [String : String] = [:],
        date: Date = .now
    ) {
        self.name = name
        self.parameters = parameters
        self.date = date
    }
}
