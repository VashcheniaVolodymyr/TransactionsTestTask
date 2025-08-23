//
//  SynchronizeService.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation
import Combine

final class SynchonizeService: Injectable {
    private let synchronizeQueue: DispatchQueue

    private lazy var allModels: [Any] = [
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
            default:
                if let synchronizable = model as? (any Synchronizable) {
                    self.synchronize(data: synchronizable)
                }
            }
        }
    }
    
    private func synchronize<SYNC: Synchronizable>(data: SYNC) where SYNC: Synchronizable {
        guard let synchronize = data as? SYNC.Synchronize else {
            return
        }
        dataManager[keyPath: data.syncKeyPath].send(synchronize)
    }
    
    func syncStoredData() {}
    
    func removeStoredData() {}
}
