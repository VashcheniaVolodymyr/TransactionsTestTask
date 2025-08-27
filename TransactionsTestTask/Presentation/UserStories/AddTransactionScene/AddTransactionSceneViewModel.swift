//
//  AddTransactionSceneViewModel.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 26.08.2025.
//

import Combine

protocol AddTransactionSceneVMP: AnyObject {
    func addTransaction(amount: String, category: Transaction.Category)
    var fieldError: CurrentValueSubject<String?, Never> { get }
    func amoudDidChanged()
}

final class AddTransactionSceneViewModel: AddTransactionSceneVMP {
    // MARK: Private
    private let transactionService: TransactionServiceProtocol
    
    // MARK: Injection
    @Injected private var navigation: Navigation
    
    // MARK: Init
    init(transactionService: TransactionServiceProtocol = TransactionService()) {
        self.transactionService = transactionService
    }
    
    // MARK: Protocol
    var fieldError: CurrentValueSubject<String?, Never> = .init(nil)
    
    func amoudDidChanged() {
        self.fieldError.send(nil)
    }
    
    func addTransaction(amount: String, category: Transaction.Category) {
        switch transactionService.withdrawal(amount, category: category) {
        case .success:
            self.navigation.popViewController(animated: true)
        case .failure(let failure):
            fieldError.send(failure.clientMessage)
        }
    }
}
