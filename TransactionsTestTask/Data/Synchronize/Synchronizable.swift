//
//  Synchronizable.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine

protocol Synchronizable {
    associatedtype Synchronize
    var syncKeyPath: WritableKeyPath<DataManager, CurrentValueSubject<Synchronize, Never>> { get }
}
