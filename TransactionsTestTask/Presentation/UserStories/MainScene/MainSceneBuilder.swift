//
//  MainSceneBuilder.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import UIKit

extension Scenes {
    static func mainScene() -> any SceneBuilderProtocol {
        struct Scene: SceneBuilderProtocol {
            var transition: SceneTransitionMethod = .root(animated: true, option: .transitionCrossDissolve)
            func buildScene() -> UIViewController {
                let viewController = MainScene(viewModel: MainSceneViewModel())
                return viewController
            }
        }
        
        return Scene()
    }
}
