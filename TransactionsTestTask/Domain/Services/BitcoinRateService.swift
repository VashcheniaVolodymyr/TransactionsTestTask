//
//  BitcoinRateService.swift
//  TransactionsTestTask
//
//

import Combine

/// Rate Service should fetch data from https://api.coindesk.com/v1/bpi/currentprice.json
/// Fetching should be scheduled with dynamic update interval
/// Rate should be cached for the offline mode
/// Every successful fetch should be logged with analytics service
/// The service should be covered by unit tests

final class BitcoinRateService: Injectable {
    var rate: CurrentValueSubject<Double, Never> = .init(0)
    
    private var cancelBag: Set<AnyCancellable> = []
    
    @Injected private var dataManager: DataManager
    
    private lazy var useCase: ExchangeRateApiUseCase = {
        return ExchangeRateApiUseCaseImpl()
    }()
    
    init() {
        bincoinRatePublisher
            .assign(to: \.value, on: rate, ownership: .weak)
            .store(in: &cancelBag)
    }
    
    private lazy var bincoinRatePublisher: AnyPublisher<Double, Never> = {
        return dataManager.exchangeRate
            .compactMap { $0?.price(for: .bitcoin, vs: .usd) }
            .removeDuplicates()
            .share()
            .eraseToAnyPublisher()
    }()
    
    
    func syncRate() {
        useCase.syncRate(ids: .bitcoin, vs: .usd)
    }
}
