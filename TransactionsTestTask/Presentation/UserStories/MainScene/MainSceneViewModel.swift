//
//  MainSceneViewModel.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation
import Combine

protocol MainSceneVMP: AnyObject {
    var rate: CurrentValueSubject<Double, Never> { get }
    var balance: CurrentValueSubject<Double, Never> { get }
    var historySections: CurrentValueSubject<[TableSection<String, Transaction>], Never> { get }
    
    func loadNextPageOfHistory()
    func didTapAddTransaction()
    func deposit(amount: Double)
    func viewDidLoad()
}

final class MainSceneViewModel: MainSceneVMP {
    var rate: CurrentValueSubject<Double, Never> = .init(0)
    var balance: CurrentValueSubject<Double, Never> = .init(0)
    var historySections: CurrentValueSubject<[TableSection<String, Transaction>], Never> = .init([])
    var cancelBag = Set<AnyCancellable>()
    var currentPage: Int = 0
    
    @Injected private var bitcoinRateService: BitcoinRateService
    @Injected private var dataManager: DataManager
    
    private let transactionsService: TransactionServiceProtocol
    private let historyService: HistoryServiceProtocol
    
    init(
        transactionService: TransactionServiceProtocol = TransactionService(),
        historyService: HistoryServiceProtocol = HistoryService()
    ) {
        self.transactionsService = transactionService
        self.historyService = historyService
        
        dataManager.balance
            .map { $0.value }
            .removeDuplicates()
            .assign(to: \.value, on: balance, ownership: .weak)
            .store(in: &cancelBag)
        
        bitcoinRateService.rate
            .removeDuplicates()
            .assign(to: \.value, on: rate, ownership: .weak)
            .store(in: &cancelBag)
    }
    
    deinit {
        cancelBag.removeAll()
    }
    
    func viewDidLoad() {
        bitcoinRateService.syncRate()
        let transactions = historyService.grouptedHistory(limit: 20, page: 1)
        self.historySections.send(transactions)
    }
    
    func loadNextPageOfHistory() {
        currentPage += 1
        
        let transactions = historyService.grouptedHistory(limit: 20, page: currentPage)
        let updatedTransactions = historySections.value + transactions
        self.historySections.send(updatedTransactions)
    }
    
    func deposit(amount: Double) {
        transactionsService.deposit(amount)
    }
    
    func didTapAddTransaction() {
        
    }
    
    func didTapDeposit() {
        
    }
}
