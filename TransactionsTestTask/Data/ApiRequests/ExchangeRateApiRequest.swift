//
//  ExchangeRateApiRequest.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//


enum ExchangeRateApiRequest {
    case rate(ids: Currency, vs: Currency)
}

extension ExchangeRateApiRequest: APIRequest {
    var path: String {
        switch self {
        case .rate:
            return "api.coingecko.com/api/v3/simple/price"
        }
    }
    
    var method: HTTPMethod {
        return .get
    }
    
    var parametrs: Parameters? {
        switch self {
        case .rate(ids: let ids, vs: let vs):
            return ["ids": ids.rawValue, "vs_currencies": vs.rawValue]
        }
    }
}
