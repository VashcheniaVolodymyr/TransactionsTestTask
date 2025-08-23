//
//  MainSceneViewModel.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Foundation
import Combine

protocol MainSceneVMP: AnyObject {
    var balance: CurrentValueSubject<Double, Never> { get }
    func viewDidLoad()
}

final class MainSceneViewModel: MainSceneVMP {
    var balance: CurrentValueSubject<Double, Never> = .init(0)
    var cancelBag = Set<AnyCancellable>()
    
    @Injected private var bitcoinRateService: BitcoinRateService
    
    init() {
        bitcoinRateService.onRateUpdate
            .removeDuplicates()
            .assign(to: \.value, on: balance, ownership: .weak)
            .store(in: &cancelBag)
        
        
//        let request = ExchangeRateApiRequest.rate(ids: .bitcoin, vs: .usd)
//        let networkRequest = NetworkRequest(request: request, dto: ExchangeRateDTO.self)
        
//        networkRequestService.callBack(request: networkRequest, callbackQueue: .main) { result in
//            switch result {
//            case .success(let value):
//                print(value)
//            case .failure(let error):
//                print(error)
//            }
//        }
        
//        let subs = networkRequestService.synchronize(request: networkRequest, callbackQueue: .main)
//        
//        dataManager.exchangeRate
//            .sink { rate in
//                print(rate?.price(for: .bitcoin, vs: .usd))
//            }
//            .store(in: &cancellabled)
        
    }
    
    func viewDidLoad() {
        bitcoinRateService.syncRate()
    }
}
