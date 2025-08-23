//
//  DTOConvertible.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

protocol DTOConvertible {
    associatedtype DTO
    func dto() -> DTO
}
