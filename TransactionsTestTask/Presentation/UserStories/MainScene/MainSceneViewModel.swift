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
    private var cancellables = Set<AnyCancellable>()
    private var currentPage: Int = 1
    
    // MARK: Injection
    @Injected private var bitcoinRateService: BitcoinRateService
    @Injected private var dataManager: DataManager
    @Injected private var navigation: Navigation
    
    private let transactionsService: TransactionServiceProtocol
    private let historyService: HistoryServiceProtocol
    
    init(
        transactionService: TransactionServiceProtocol = TransactionService(),
        historyService: HistoryServiceProtocol = HistoryService()
    ) {
        self.transactionsService = transactionService
        self.historyService = historyService
        self.bind()
    }
    
    deinit {
        cancellables.removeAll()
    }
    
    func viewDidLoad() {
        bitcoinRateService.syncRate()
        let transactions = historyService.loadHistory(limit: 20, page: currentPage)
        let groupted = groupTransactionsByDay(transactions)
        self.historySections.send(groupted)
    }
    
    func didTapAddTransaction() {
        self.navigation.navigate(builder: Scenes.addTransactionScene())
    }
    
    func deposit(amount: Double) {
        self.transactionsService.deposit(amount)
    }
    
    func loadNextPageOfHistory() {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            self.currentPage += 1
            
            let loadedTransactions = self.historyService.loadHistory(limit: 20, page: currentPage)
            
            print("Loaded")
            loadedTransactions.forEach { transaction in
                print(transaction.uuid.uuidString)
            }
            
            if loadedTransactions.isEmpty.NOT {
                let currentTransactions: [Transaction] = self.historySections.value.reduce(into: []) { partialResult, section in
                    partialResult += section.items
                }
                
                let updatedTransactions = currentTransactions + loadedTransactions
                
                let groupted = self.groupTransactionsByDay(updatedTransactions)
                self.historySections.send(groupted)
            }
        }
    }
    
    // MARK: Private methods
    private func bind() {
        dataManager.balance
            .map { $0.value }
            .removeDuplicates()
            .assign(to: \.value, on: balance, ownership: .weak)
            .store(in: &cancellables)
        
        bitcoinRateService.rate
            .removeDuplicates()
            .assign(to: \.value, on: rate, ownership: .weak)
            .store(in: &cancellables)
        
        
        historyService.historyDidChange
            .sink { [weak self] in
                self?.loadHistory()
            }
            .store(in: &cancellables)
    }
    
    private func groupTransactionsByDay(_ transactions: [Transaction]) -> [TableSection<String, Transaction>] {
        let calendar = Calendar.current
        
        let grouped = Dictionary(grouping: transactions) { tx -> Date in
            let components = calendar.dateComponents([.year, .month, .day], from: tx.createdAt)
            return calendar.date(from: components)!
        }
        
        let sections = grouped
            .map { TableSection(id: $0.key.dateString(), items: $0.value.sorted(by: { $0.createdAt > $1.createdAt })) }
            .sorted(by: { $0.id > $1.id })
        
        return sections
    }
    
    private func loadHistory() {
        self.currentPage = 1
        let transactions = historyService.loadHistory(limit: 20, page: currentPage)
        let groupted = groupTransactionsByDay(transactions)
        self.historySections.send(groupted)
    }
}
