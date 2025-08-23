//
//  NetworkRequestManager.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine
import Foundation

protocol NetworkRequestServiceProtocol: AnyObject {
    func synchronize<DTO: Responsable>(
        request: NetworkRequest<DTO>
    )
    
    func callBack<DTO: Responsable>(
        request: NetworkRequest<DTO>,
        callbackQueue: DispatchQueue,
        result: @escaping Callback<Result<DTO.DTO, APIError>>
    )
    
    func publisher<DTO: Responsable>(
        request: NetworkRequest<DTO>,
        callbackQueue: DispatchQueue
    ) -> AnyPublisher<DTO.DTO, APIError>

}

final class NetworkRequestService: NetworkRequestServiceProtocol {
    @Injected private var synchonizeService: SynchonizeService
    
    private let networkService: NetworkService
    
    init(networkService: NetworkService = BaseNetworkService()) {
        self.networkService = networkService
    }
    
    func publisher<DTO>(
        request: NetworkRequest<DTO>,
        callbackQueue: DispatchQueue
    ) -> AnyPublisher<DTO.DTO, APIError> where DTO : Responsable {
        return performRequest(request: request, callbackQueue: callbackQueue)
            .eraseToAnyPublisher()
    }
    
    func synchronize<DTO: Responsable>(request: NetworkRequest<DTO>) {
        return performRequest(request: request, callbackQueue: .global(qos: .utility))
            .sinkAsync { result in
                switch result {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] dto in
                self?.synchonizeService.synchronize(dto)
            }

    }
    
    func callBack<DTO: Responsable>(
        request: NetworkRequest<DTO>,
        callbackQueue: DispatchQueue,
        result: @escaping Callback<Result<DTO.DTO, APIError>>
    ) {
        performRequest(request: request, callbackQueue: callbackQueue)
            .sinkAsync(
                receiveCompletion: { completion in
                    switch completion {
                    case .finished:
                        break
                    case .failure(let failure):
                        result(.failure(failure))
                    }
                }, receiveValue: { dto in
                    result(.success(dto))
                }
            )
    }
    
    private func performRequest<DTO: Responsable>(
        request: NetworkRequest<DTO>,
        callbackQueue: DispatchQueue
    ) -> AnyPublisher<DTO.DTO, APIError> {
        return networkService.dataTaskPublisher(request.request, callbackQueue: callbackQueue)
            .map(\.data)
            .decode(type: request.dto, decoder: JSONDecoder())
            .map { $0.dto() }
            .mapError { APIError.response(.decodingError($0)) }
            .eraseToAnyPublisher()
    }
}
