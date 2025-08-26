//
//  HistoryService.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//

import CoreData

protocol HistoryServiceProtocol: AnyObject {
    func grouptedHistory(limit: Int, page: Int) -> [TableSection<String, Transaction>]
}

final class HistoryService: HistoryServiceProtocol {
    
    func grouptedHistory(limit: Int, page: Int) -> [TableSection<String, Transaction>] {
        let items = loadHistory(limit: limit, page: page)
        
        return [.init(id: Date.now.dateString(), items: items)]
    }
    
    private func loadHistory(limit: Int, page: Int) -> [Transaction] {
        let request: NSFetchRequest<TransactionCD> = TransactionCD.fetchRequest()

        request.sortDescriptors = [NSSortDescriptor(key: "createdAt", ascending: false)]
        request.fetchLimit = limit
        request.fetchOffset = page <= 1 ? 0 : page * limit

        do {
            let results = try CoreDataStack.viewContext.fetch(request)
            
            let domains = results.map { $0.domain() }
            return domains
        } catch {
            return []
        }
    }
}

fileprivate extension Date {
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
