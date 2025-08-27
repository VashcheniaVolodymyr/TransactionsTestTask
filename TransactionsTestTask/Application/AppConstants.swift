//
//  AppConstants.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

public struct AppConstants {
    public enum ApiClientError {
        public static let somethingWhentWrong = "Something went wrong"
        public static let invalidURL = "Invalid URL"
    }
    
    public enum TransactionError {
        public static let insufficientFunds = "Insufficient funds"
        public static let depositMustBeGreaterThanZero = "Amount must be geater than zero"
        public static let withdrawalMustBeGreaterThanZero = "Amount must be geater than zero"
        public static let invalidAmount = "Invalid amount"
    }
    
    public enum History {
        public static let noTransactions = "No transactions"
        public static let your_history_will_appear_here = "Your history will appear here."
    }
}

