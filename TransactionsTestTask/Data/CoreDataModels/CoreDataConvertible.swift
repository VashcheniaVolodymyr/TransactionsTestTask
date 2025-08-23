//
//  CoreDataConvertible.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

protocol CoreDataConvertible {
    associatedtype CORE: DOMAINConvertible
    func coreData() -> CORE
}
