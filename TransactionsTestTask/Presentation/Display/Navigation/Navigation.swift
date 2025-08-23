//
//  Navigation.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import UIKit

final class Navigation: Injectable {
    private lazy var window: UIWindow = UIWindow()
    private lazy var currentNavigationController: UINavigationController = .init()
    
    init() { }
    
    convenience init(
        window: UIWindow = UIWindow(),
        currentNavigationController: BaseNavigationController = .init()
    ) {
        self.init()
        self.window = window
        self.currentNavigationController = currentNavigationController
    }
    
    func start(window: UIWindow) {
        self.window = window
        self.navigate(builder: Scenes.mainScene())
    }
    
    lazy var topViewController: UIViewController? = {
        currentNavigationController.topViewController
    }()
    
    lazy var visibleController: UIViewController? = {
        currentNavigationController.visibleViewController
    }()
    
    lazy var currentController: UIViewController? = {
        currentNavigationController.viewControllers.last
    }()
    
    func navigate<SceneBuilder>(builder: SceneBuilder, completion: VoidCallBack? = nil)
    where SceneBuilder: SceneBuilderProtocol, SceneBuilder.Scene: UIViewController {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            switch builder.transition {
            case .push(animated: let isAnimated):
                self.currentNavigationController.pushViewController(builder.buildScene(), animated: isAnimated)
            case .root(animated: let isAnimated, option: let option):
                if self.currentNavigationController.viewControllers.count > 1 {
                    self.currentNavigationController.viewControllers = []
                }
                
                self.root(
                    navigation: BaseNavigationController(rootViewController: builder.buildScene()),
                    animated: isAnimated,
                    animateOption: option,
                    completion: completion
                )
            }
        }
    }
    

    private func root(
        navigation: BaseNavigationController,
        animated: Bool = false,
        animateOption: UIView.AnimationOptions? = nil,
        completion: VoidCallBack? = nil
    ) {
        if let option = animateOption, animated {
            window.rootViewController = navigation
            currentNavigationController = navigation
            window.makeKeyAndVisible()
            completion?()
            UIView.transition(
                with: window,
                duration: 0.5,
                options: option,
                animations: nil,
                completion: nil
            )
        } else {
            UIView.performWithoutAnimation {
                window.rootViewController = navigation
                currentNavigationController = navigation
                window.makeKeyAndVisible()
                completion?()
            }
        }
    }
}
