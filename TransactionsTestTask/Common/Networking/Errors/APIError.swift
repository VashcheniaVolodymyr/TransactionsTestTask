//
//  APIError.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation

public enum APIBuildRequestError: Error, ClientPresentableError {
    case invalidURL
    
    public var clientMessage: String {
        switch self {
        case .invalidURL:
            return AppConstants.ApiClientError.invalidURL
        }
    }
}

public enum APIResponseError: Error, ClientPresentableError {
    case noResponse
    case clientError(statusCode: Int, data: Data)
    case decodingError(Error)
    
    public var clientMessage: String {
        return AppConstants.ApiClientError.somethingWhentWrong
    }
}

public enum APIError: Error {
    case buildRequest(APIBuildRequestError)
    case response(APIResponseError)
    case undefined(request: URLRequest?, error: any Error)
}

extension APIError: ClientPresentableError {
    public var clientMessage: String {
        switch self {
        case .buildRequest(let aPIBuildRequestError):
            return aPIBuildRequestError.clientMessage
        case .response(let aPIResponseError):
            return aPIResponseError.clientMessage
        case .undefined(_, let error):
            return error.localizedDescription
        }
    }
}
