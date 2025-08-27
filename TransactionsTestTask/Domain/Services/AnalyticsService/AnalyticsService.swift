//
//  AnalyticsService.swift
//  TransactionsTestTask
//
//

import Foundation

/// Analytics Service is used for events logging
/// The list of reasonable events is up to you
/// It should be possible not only to track events but to get it from the service
/// The minimal needed filters are: event name and date range
/// The service should be covered by unit tests

protocol AnalyticsService: AnyObject {
    func trackEvent<T: AnalyticsConvertible>(convertible: T)
    func trackEvent(name: AnalyticsEventName, parameters: [String: String])
    func getEvents(name: AnalyticsEventName?, from: Date?, to: Date?) -> [AnalyticsEvent]
}

final class AnalyticsServiceImpl: Injectable {
    // MARK: Private
    private var events: Atomic<[AnalyticsEvent]> = .init(value: [])
    
    // MARK: - Init
    init() { }
}

// MARK: Protocol
extension AnalyticsServiceImpl: AnalyticsService {
    func trackEvent<T>(convertible: T) where T : AnalyticsConvertible {
        let event = convertible.event()
        self.trackEvent(name: event.name, parameters: event.parameters)
    }
    
    func trackEvent(name: AnalyticsEventName, parameters: [String: String] = [:]) {
        let event = AnalyticsEvent(
            name: name,
            parameters: parameters,
            date: .now
        )
        
        events.modify { current in
            var copy = current
            copy.append(event)
            return copy
        }
    }
    
    func getEvents(name: AnalyticsEventName? = nil, from: Date? = nil, to: Date? = nil) -> [AnalyticsEvent] {
        return events.with { current in
            current.filter { event in
                var matches = true
                if let name = name {
                    matches = matches && event.name == name
                }
                if let from = from {
                    matches = matches && event.date >= from
                }
                if let to = to {
                    matches = matches && event.date <= to
                }
                return matches
            }
        }
    }
}
