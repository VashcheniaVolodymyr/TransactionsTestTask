//
//  SceneBuilder.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import UIKit

struct Scenes {}

protocol SceneBuilderProtocol {
    associatedtype Scene: UIViewController
    func buildScene() -> Scene
    var transition: SceneTransitionMethod { get set }
    var transitionStyle: UIModalTransitionStyle? { get set }
    var withNaviveAnimation: Bool { get set }
}

extension SceneBuilderProtocol {
    var transition: SceneTransitionMethod {
        get {
            return .root()
        }
        set {
            transition = newValue
        }
    }
    
    var withNaviveAnimation: Bool {
        get {
            return true
        }
        set {
            withNaviveAnimation = newValue
        }
    }
    
    var transitionStyle: UIModalTransitionStyle? {
        get {
            return nil
        }
        set {
            transitionStyle = newValue
        }
    }
}
