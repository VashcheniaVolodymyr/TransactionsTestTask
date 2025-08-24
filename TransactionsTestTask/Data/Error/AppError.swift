//
//  AppError.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 24.08.2025.
//

enum CoreDataError: Error {
    case trySaveWhenHasNotChanges
    case undefined(Error)
}

enum AppError: Error {
    case coreDataError(CoreDataError)
    case networkingError(Error)
    case undefined(Error)
}
