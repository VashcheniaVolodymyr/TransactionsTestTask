//
//  URLRequestConvertible.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation

public protocol URLRequestConvertible {
    func asURLRequest() throws -> URLRequest
}
