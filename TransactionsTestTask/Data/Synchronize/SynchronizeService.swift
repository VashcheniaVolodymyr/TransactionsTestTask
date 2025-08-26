//
//  SynchronizeService.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation
import Combine
import CoreData

final class SynchonizeService: Injectable {
    private let synchronizeQueue: DispatchQueue

    private lazy var allModels: [NSManagedObject.Type] = [
        ExchangeRateCD.self,
        BalanceCD.self,
        TransactionCD.self
    ]

    // MARK: Initialization
    init() {
        self.synchronizeQueue = .init(label: String(describing: Self.self) + ".synchronizeQueue")
    }

    // MARK: Injection
    @Injected private var dataManager: DataManager

    // MARK: Public methods
    func synchronize<MODEL>(_ model: MODEL) {
        typealias DTO = DTOConvertible
        typealias DOMAIN = DOMAINConvertible
        typealias CORE_DATA = CoreDataConvertible
        
        synchronizeQueue.async { [weak self] in
            guard let self = self else { return }
            
            switch model {
            case let dtoConvertible as (any DTO):
                let dto = dtoConvertible.dto()
                
                switch dto {
                case let coreDataConvertible as (any CORE_DATA):
                    let coreDataModel = coreDataConvertible.coreData()
                
                    if (coreDataModel as? UniqueEntity).notNil {
                        coreDataModel.saveUnique(context: CoreDataStack.viewContext)
                        
                        if let domainConvertible = coreDataModel as? (any DOMAIN) {
                            let domain = domainConvertible.domain()
                            
                            if let synchronizable = domain as? (any Synchronizable) {
                                self.synchronize(data: synchronizable)
                            }
                        }
                    } else {
                        coreDataModel.save(context: CoreDataStack.viewContext)
                        
                        if let domainConvertible = coreDataModel as? (any DOMAIN) {
                            let domain = domainConvertible.domain()
                            
                            if let synchronizable = domain as? (any Synchronizable) {
                                self.synchronize(data: synchronizable)
                            }
                        }
                    }
                case let domainConvertible as (any DOMAIN):
                    let domain = domainConvertible.domain()
                    
                    if let synchronizable = domain as? (any Synchronizable) {
                        self.synchronize(data: synchronizable)
                    }
                default:
                    break
                }
            case let domainConvertible as (any DOMAIN):
                let domain = domainConvertible.domain()
                
                if let synchronizable = domain as? (any Synchronizable) {
                    self.synchronize(data: synchronizable)
                }
            case let coreDataConvertible as (any CORE_DATA):
                let coreDataModel = coreDataConvertible.coreData()
            
                if (coreDataModel as? UniqueEntity).notNil {
                    coreDataModel.saveUnique(context: CoreDataStack.viewContext)
                    
                    if let domainConvertible = coreDataModel as? (any DOMAIN) {
                        let domain = domainConvertible.domain()
                        
                        if let synchronizable = domain as? (any Synchronizable) {
                            self.synchronize(data: synchronizable)
                        }
                    }
                } else {
                    coreDataModel.save(context: CoreDataStack.viewContext)
                    
                    if let domainConvertible = coreDataModel as? (any DOMAIN) {
                        let domain = domainConvertible.domain()
                        
                        if let synchronizable = domain as? (any Synchronizable) {
                            self.synchronize(data: synchronizable)
                        }
                    }
                }
            default:
                if let synchronizable = model as? (any Synchronizable) {
                    self.synchronize(data: synchronizable)
                }
            }
        }
    }
    
    func syncStoredData() {
        allModels.forEach { type in
            let featch = fetchAll(type, context: CoreDataStack.viewContext)
            
            if let first = featch.first as? UniqueEntity {
                self.synchronize(first)
            } else {
                self.synchronize(featch) // TODO: Implement sync collections in the future
            }
        }
    }
    
    func fetchAll<T: NSManagedObject>(
        _ type: T.Type,
        context: NSManagedObjectContext = CoreDataStack.viewContext
    ) -> [T] {
        let request = NSFetchRequest<T>(entityName: String(describing: type))
       
        do {
            return try context.fetch(request)
        } catch {
            return []
        }
    }
    
    func removeStoredData() {}
    
    // MARK: Private methods
    private func synchronize<SYNC: Synchronizable>(data: SYNC) {
        guard let synchronized = data as? SYNC.Synchronize else {
            return
        }
        dataManager[keyPath: data.syncKeyPath].send(synchronized)
    }
}
