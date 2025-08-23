//
//  URLRequest+Extensions.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation

extension URLRequest {
    public typealias Response = (data: Data, response: HTTPURLResponse)
}

extension URLRequest {
    public static func validate<S: Sequence>(
        statusCode acceptableStatusCodes: S,
        response: HTTPURLResponse
    ) -> Result<Void, Error> where S.Element == Int {
        if acceptableStatusCodes.contains(response.statusCode) {
            return .success(())
        } else {
            return .failure(URLError(.badServerResponse))
        }
    }
}

extension URLRequest {
    public init(url: any URLConvertible, method: HTTPMethod, headers: [String: String]? = nil) throws {
        let url = try url.asURL()

        self.init(url: url)

        httpMethod = method.rawValue
        allHTTPHeaderFields = headers
    }
}
