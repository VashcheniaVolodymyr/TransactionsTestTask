//
//  SinkAsync.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import Combine

public extension Publisher {
    func sinkAsync(
        receiveCompletion: @escaping (Subscribers.Completion<Failure>) -> Void = { _ in },
        receiveValue: @escaping (Output) -> Void = { _ in }
    ) {
        var cancellable: AnyCancellable?
        
        cancellable = self
            .handleEvents(
                receiveCancel: {
                    if cancellable.notNil {
                        cancellable = nil
                    }
                }
            )
            .sink { result in
                receiveCompletion(result)
                cancellable = nil
            } receiveValue: { value in
                receiveValue(value)
            }
    }
}

public enum ObjectOwnership {
    case strong
    case weak
    case unowned
}

public extension Publisher where Self.Failure == Never {
    func assign<Root: AnyObject>(to keyPath: ReferenceWritableKeyPath<Root, Self.Output>,
                                 on object: Root,
                                 ownership: ObjectOwnership = .strong) -> AnyCancellable {
        switch ownership {
        case .strong:
            return assign(to: keyPath, on: object)
        case .weak:
            return sink { [weak object] value in
                object?[keyPath: keyPath] = value
            }
        case .unowned:
            return sink { [unowned object] value in
                object[keyPath: keyPath] = value
            }
        }
    }
}
