//
//  BackgroundRepeatingTimer.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 27.08.2025.
//
import Foundation

final class BackgroundRepeatingTimer {
    // MARK: Private
    private let timer = Atomic<DispatchSourceTimer?>(value: nil)
    private let timeout: Double
    private let `repeat`: Bool
    private let completion: (BackgroundRepeatingTimer) -> Void
    private let queue: DispatchQueue
    
    
    // MARK: Init
    public init(
        timeout: Double,
        `repeat`: Bool,
        completion: @escaping VoidCallBack,
        queue: DispatchQueue
    ) {
        self.timeout = timeout
        self.`repeat` = `repeat`
        self.completion = { _ in
            completion()
        }
        self.queue = queue
    }
    
    public init(
        timeout: Double,
        `repeat`: Bool,
        completion: @escaping Callback<BackgroundRepeatingTimer>,
        queue: DispatchQueue
    ) {
        self.timeout = timeout
        self.`repeat` = `repeat`
        self.completion = completion
        self.queue = queue
    }
    
    deinit {
        self.invalidate()
    }
    
    // MARK: Public
    public func start() {
        let source = DispatchSource.makeTimerSource(queue: self.queue)
        
        source.setEventHandler(handler: { [weak self] in
            guard let self = self else { return }
            self.completion(self)
            
            if self.`repeat`.NOT {
                self.invalidate()
            }
        })
        
        _ = self.timer.swap(source)
        
        if self.`repeat` {
            let time: DispatchTime = DispatchTime.now() + self.timeout
            source.schedule(deadline: time, repeating: self.timeout)
        } else {
            let time: DispatchTime = DispatchTime.now() + self.timeout
            source.schedule(deadline: time)
        }
        
        source.resume()
    }
    
    public func invalidate() {
        _ = self.timer.modify { timer in
            timer?.cancel()
            return nil
        }
    }
}
