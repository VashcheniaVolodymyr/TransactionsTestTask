//
//  HistoryService.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//

import Combine
import CoreData

protocol HistoryServiceProtocol: AnyObject {
    func loadHistory(limit: Int, page: Int) -> [Transaction]
    var historyDidChange: AnyPublisher<Void, Never> { get }
}

final class HistoryService: HistoryServiceProtocol {
    // MARK: Protocol
    lazy var historyDidChange: AnyPublisher<Void, Never> = {
        return CDPublisher(request: TransactionCD.fetchRequest(), context: CoreDataStack.viewContext)
            .dropFirst(2)
            .map { _ in () }
            .catch { _ in Empty<Void, Never>() }
            .share()
            .eraseToAnyPublisher()
    }()
    
    func loadHistory(limit: Int, page: Int) -> [Transaction] {
        let request: NSFetchRequest<TransactionCD> = TransactionCD.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        request.fetchLimit = limit
        request.fetchOffset = max(0, (page - 1) * limit)

        do {
            let results = try CoreDataStack.viewContext.fetch(request)
            
            let domains = results.map { $0.domain() }
            return domains
        } catch {
            return []
        }
    }
}
