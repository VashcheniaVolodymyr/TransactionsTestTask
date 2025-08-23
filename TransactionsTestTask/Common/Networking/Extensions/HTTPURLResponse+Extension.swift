//
//  HTTPURLResponse+Extension.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation

extension HTTPURLResponse {
    var isResponseOK: Bool {
        return (200..<299).contains(statusCode)
    }
}
