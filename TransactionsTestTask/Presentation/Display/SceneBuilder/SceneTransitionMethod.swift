//
//  SceneTransitionMethod.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import UIKit

enum SceneTransitionMethod: Equatable {
    case push(animated: Bool = false)
    case root(animated: Bool = false, option: UIView.AnimationOptions? = nil)
}
