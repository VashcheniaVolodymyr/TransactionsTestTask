//
//  TransactionService.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//

enum TransactionServiceError: Error {
    case insufficientFunds
    case depositMustBeGreaterThanZero
    case withdrawalMustBeGreaterThanZero
}

protocol TransactionServiceProtocol: AnyObject {
    @discardableResult
    func deposit(_ amount: Double) -> Result<Void, TransactionServiceError>
    func withdrawal(_ amount: Double, category: Transaction.Category) -> Result<Void, TransactionServiceError>
}

final class TransactionService: TransactionServiceProtocol {
    @Injected private var dataManager: DataManager
    @Injected private var synchonizeService: SynchonizeService
    
    @discardableResult
    func deposit(_ amount: Double) -> Result<Void, TransactionServiceError> {
        guard amount > 0 else { return .failure(.depositMustBeGreaterThanZero)}
        
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
        
        return .success(Void())
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
        
        return .success(Void())
    }
}
