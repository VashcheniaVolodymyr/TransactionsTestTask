//
//  AddTransactionSceneBuilder.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 26.08.2025.
//
import UIKit

extension Scenes {
    static func addTransactionScene() -> any SceneBuilderProtocol {
        struct Scene: SceneBuilderProtocol {
            var transition: SceneTransitionMethod = .push(animated: true)
            func buildScene() -> UIViewController {
                let viewController = AddTransactionScene(viewModel: AddTransactionSceneViewModel())
                return viewController
            }
        }
        
        return Scene()
    }
}
