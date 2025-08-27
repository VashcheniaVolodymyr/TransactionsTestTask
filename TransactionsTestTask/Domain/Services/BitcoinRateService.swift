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
    // MARK: Private
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var useCase: ExchangeRateApiUseCase = {
        return ExchangeRateApiUseCaseImpl()
    }()
    
    private lazy var backgroundTimer: BackgroundRepeatingTimer = {
        return BackgroundRepeatingTimer(
            timeout: 30,
            repeat: true,
            completion: { [weak self] in
                self?.syncRate()
            },
            queue: .global(qos: .background)
        )
    }()
    
    private lazy var bincoinRatePublisher: AnyPublisher<Double, Never> = {
        return dataManager.exchangeRate
            .compactMap { $0?.price(for: .bitcoin, vs: .usd) }
            .share()
            .eraseToAnyPublisher()
    }()
    
    // MARK: Public
    var rate: CurrentValueSubject<Double, Never> = .init(0)
    
    // MARK: Injection
    @Injected private var dataManager: DataManager
    @Injected private var analyticsService: AnalyticsServiceImpl
    
    // MARK: Init
    init() {
        bincoinRatePublisher
            .removeDuplicates()
            .assign(to: \.value, on: rate, ownership: .weak)
            .store(in: &cancellables)
        
        bincoinRatePublisher
            .sink(receiveValue: { [weak self] rate in
                guard let self = self else { return }
                self.analyticsService.trackEvent(
                    name: .rateUpdated,
                    parameters: ["rate" : String(rate)]
                )
            })
            .store(in: &cancellables)
        
        
        backgroundTimer.start()
    }
    
    deinit {
        backgroundTimer.invalidate()
    }
    
    
    // MARK: Public
    func syncRate() {
        useCase.syncRate(ids: .bitcoin, vs: .usd)
    }
}
