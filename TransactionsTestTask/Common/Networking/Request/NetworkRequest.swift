//
//  SynchronizedRequest.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

protocol NetworkRequestProtocol {
    associatedtype DTO: Responsable
    var request: APIRequest { get set }
    var dto: DTO.Type { get set }
}

struct NetworkRequest<DTO> where DTO: Responsable {
    var request: APIRequest
    var dto: DTO.Type
}

extension NetworkRequest: NetworkRequestProtocol {}
