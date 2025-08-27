//
//  TransactionService.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//

protocol TransactionServiceProtocol: AnyObject {
    @discardableResult
    func deposit(_ amount: Double) -> Result<Void, TransactionServiceError>
    func withdrawal(_ amount: String, category: Transaction.Category) -> Result<Void, TransactionServiceError>
    func withdrawal(_ amount: Double, category: Transaction.Category) -> Result<Void, TransactionServiceError>
}

final class TransactionService: TransactionServiceProtocol {
    // MARK: Injection
    @Injected private var dataManager: DataManager
    @Injected private var synchonizeService: SynchonizeService
    @Injected private var analyticsService: AnalyticsServiceImpl
    
    // MARK: Protocol
    @discardableResult
    func deposit(_ amount: Double) -> Result<Void, TransactionServiceError> {
        guard amount > 0 else {
            return .failure(.depositMustBeGreaterThanZero)
        }
        
        let transaction = Transaction(
            amount: amount,
            category: nil,
            createdAt: .now,
            type: .deposit
        )
        
        let updatedBalace = dataManager.balance.value.value + amount
        let newBalance = Balance(value: updatedBalace)
        
        self.synchonizeService.synchronize(newBalance)
        self.synchonizeService.synchronize(transaction)
        
        analyticsService.trackEvent(convertible: transaction)
        
        return .success(Void())
    }
    
    func withdrawal(_ amount: String, category: Transaction.Category) -> Result<Void, TransactionServiceError> {
        guard let amount = Double(amount.replacingOccurrences(of: ",", with: ".")) else {
            return .failure(.invalidAmount)
        }
        
        return withdrawal(amount, category: category)
    }
    
    func withdrawal(_ amount: Double, category: Transaction.Category) -> Result<Void, TransactionServiceError> {
        guard amount > 0 else {
            return .failure(.withdrawalMustBeGreaterThanZero)
        }
        
        guard (dataManager.balance.value.value - amount) >= 0 else {
            return .failure(.insufficientFunds)
        }
        
        let transaction = Transaction(
            amount: amount,
            category: category,
            createdAt: .now,
            type: .withdrawal
        )
        
        let updatedBalace = dataManager.balance.value.value - amount
        let newBalance = Balance(value: updatedBalace)
        
        self.synchonizeService.synchronize(newBalance)
        self.synchonizeService.synchronize(transaction)
        
        analyticsService.trackEvent(convertible: transaction)
        
        return .success(Void())
    }
}
