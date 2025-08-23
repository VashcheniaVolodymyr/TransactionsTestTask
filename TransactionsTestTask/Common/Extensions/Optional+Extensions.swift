//
//  Optional+Extensions.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//


extension Optional {
    var isNil: Bool {
        self == nil
    }
    
    var notNil: Bool {
        self != nil
    }
}
