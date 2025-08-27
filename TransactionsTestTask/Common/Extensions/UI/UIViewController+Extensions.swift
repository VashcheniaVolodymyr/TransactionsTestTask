//
//  UIViewController+Extensions.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 27.08.2025.
//

import UIKit

extension UIViewController {
    func bindKeyboard(to bottomConstraint: NSLayoutConstraint, extraOffset: CGFloat = 0) {
        NotificationCenter.default.addObserver(forName: UIResponder.keyboardWillChangeFrameNotification,
                                               object: nil, queue: .main) { [weak self] notif in
            self?.keyboardWillChangeFrame(notif, bottomConstraint: bottomConstraint, padding: extraOffset)
        }
    }

    private func keyboardWillChangeFrame(_ notification: Notification, bottomConstraint: NSLayoutConstraint, padding: CGFloat = 8) {
        guard let userInfo = notification.userInfo,
              let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect,
              let duration = userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? Double,
              let curve = userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? UInt,
              let window = view.window else { return }

        let keyboardFrameInView = view.convert(endFrame, from: window)
        let keyboardHeight = max(view.bounds.maxY - keyboardFrameInView.minY, 0)

        bottomConstraint.constant = -keyboardHeight - padding

        UIView.animate(withDuration: duration,
                       delay: 0,
                       options: UIView.AnimationOptions(rawValue: curve << 16),
                       animations: {
            self.view.layoutIfNeeded()
        })
    }
}
