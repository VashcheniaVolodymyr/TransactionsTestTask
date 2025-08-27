//
//  TransactionServiceError.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 27.08.2025.
//

enum TransactionServiceError: Error, ClientPresentableError {
    case insufficientFunds
    case depositMustBeGreaterThanZero
    case withdrawalMustBeGreaterThanZero
    case invalidAmount
    
    var clientMessage: String {
        switch self {
        case .insufficientFunds:
            return AppConstants.TransactionError.insufficientFunds
        case .depositMustBeGreaterThanZero:
            return AppConstants.TransactionError.depositMustBeGreaterThanZero
        case .withdrawalMustBeGreaterThanZero:
            return AppConstants.TransactionError.withdrawalMustBeGreaterThanZero
        case .invalidAmount:
            return AppConstants.TransactionError.invalidAmount
        }
    }
}
