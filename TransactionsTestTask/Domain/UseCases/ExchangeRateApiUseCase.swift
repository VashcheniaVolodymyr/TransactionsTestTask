//
//  ExchangeRateApiUseCase.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine
import Foundation

protocol ExchangeRateApiUseCase {
    func fetchExchangeRate(ids: Currency, vs: Currency, receiveOn: DispatchQueue) -> AnyPublisher<ExchangeRate, APIError>
    func syncRate(ids: Currency, vs: Currency)
}

final class ExchangeRateApiUseCaseImpl: ExchangeRateApiUseCase {
    let networkRequestService: NetworkRequestServiceProtocol
    
    init(networkRequestService: NetworkRequestServiceProtocol = NetworkRequestService()) {
        self.networkRequestService = networkRequestService
    }
    
    func fetchExchangeRate(ids: Currency, vs: Currency, receiveOn: DispatchQueue = .main) -> AnyPublisher<ExchangeRate, APIError> {
        let request = ExchangeRateApiRequest.rate(ids: ids, vs: vs)
        let networkRequest = NetworkRequest(request: request, dto: ExchangeRateDTO.self)
        
        return networkRequestService.publisher(request: networkRequest, callbackQueue: receiveOn)
            .map { $0.domain() }
            .eraseToAnyPublisher()
    }
    
    func syncRate(ids: Currency, vs: Currency) {
        let request = ExchangeRateApiRequest.rate(ids: ids, vs: vs)
        let networkRequest = NetworkRequest(request: request, dto: ExchangeRateDTO.self)
        
        networkRequestService.synchronize(request: networkRequest)
    }
}
