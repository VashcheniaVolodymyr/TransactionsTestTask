//
//  DepositPopUp.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 26.08.2025.
//

import UIKit

final class DepositPopup: UIView, UITextFieldDelegate {
    var onConfirm: ((Double) -> Void)?
    var onCancel: (() -> Void)?
    
    private let backgroundView: UIView = {
        let blurEffect = UIBlurEffect(style: .systemThickMaterial)
        let view = UIVisualEffectView(effect: blurEffect)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let containerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 16
        view.layer.borderColor = UIColor.black.cgColor
        view.layer.borderWidth = 1
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Deposit BTC"
        label.font = .boldSystemFont(ofSize: 18)
        label.textAlignment = .center
        return label
    }()
    
    private let textField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter BTC amount"
        tf.borderStyle = .roundedRect
        tf.keyboardType = .decimalPad
        
        tf.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return tf
    }()
    
    private let amountErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.text = " "
        label.isHidden = true
        return label
    }()
    
    private lazy var cancelButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.imagePadding = 8
        config.title = "Cancel"
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.background.strokeColor = .black
        config.background.strokeWidth = 1
        config.cornerStyle = .large
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        config.image = UIImage(systemName: "minus.circle.fill", withConfiguration: symbolConfig)?
            .withTintColor(UIColor.red.withAlphaComponent(0.7), renderingMode: .alwaysOriginal)
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapCancel), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        return button
    }()
    
    private lazy var confirmButton: UIButton = {
        var config = UIButton.Configuration.filled()
        config.imagePadding = 8
        config.title = "Confirm"
        config.baseBackgroundColor = .white
        config.baseForegroundColor = .black
        config.background.strokeColor = .black
        config.background.strokeWidth = 1
        config.cornerStyle = .large
        
        let symbolConfig = UIImage.SymbolConfiguration(pointSize: 18, weight: .medium)
        config.image = UIImage(systemName: "chevron.down.square.fill", withConfiguration: symbolConfig)?
            .withTintColor(UIColor(resource: .brand), renderingMode: .alwaysOriginal)
        
        let button = UIButton(configuration: config)
        button.addTarget(self, action: #selector(didTapConfirm), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        return button
    }()
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupBackgroundTap()
        textField.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        textField.delegate = nil
    }
    
    private func setupUI() {
        addSubview(backgroundView)
        addSubview(containerView)
        
        backgroundView.frame = UIScreen.main.bounds
        
        let stack = UIStackView(
            arrangedSubviews: [
                titleLabel,
                textField,
                amountErrorLabel,
                confirmButton,
                cancelButton
            ]
        )
        
        stack.axis = .vertical
        stack.spacing = 12
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            backgroundView.leadingAnchor.constraint(equalTo: leadingAnchor),
            backgroundView.trailingAnchor.constraint(equalTo: trailingAnchor),
            backgroundView.topAnchor.constraint(equalTo: topAnchor),
            backgroundView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            containerView.topAnchor.constraint(equalTo: safeAreaLayoutGuide.topAnchor, constant: 100),
            containerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 32),
            containerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -32),
            
            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
    
    @objc private func didTapCancel() {
        onCancel?()
        dismiss()
    }
    
    @objc private func didTapConfirm() {
        if let text = textField.text?.replacingOccurrences(of: ",", with: "."), let amount = Double(text) {
            if amount > 0 {
                onConfirm?(amount)
                dismiss()
            } else {
                self.amountErrorLabel.isHidden = false
                self.amountErrorLabel.text = AppConstants.TransactionError.depositMustBeGreaterThanZero
            }
        } else {
            self.amountErrorLabel.isHidden = false
            self.amountErrorLabel.text = AppConstants.TransactionError.invalidAmount
        }
    }
    
    func show(in parent: UIView) {
        if let windowScene = UIApplication.shared.connectedScenes
            .compactMap({ $0 as? UIWindowScene })
            .first(where: { $0.activationState == .foregroundActive }),
           let window = windowScene.windows.first(where: { $0.isKeyWindow }) {
            
            self.frame = window.bounds
            window.addSubview(self)
            alpha = 0
            UIView.animate(withDuration: 0.3) {
                self.alpha = 1
                
                DispatchQueue.main.async { [weak self] in
                    self?.textField.becomeFirstResponder()
                }
            }
        }
    }
    
    private func setupBackgroundTap() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapBackground))
        backgroundView.addGestureRecognizer(tapGesture)
        backgroundView.isUserInteractionEnabled = true
    }
    
    @objc private func didTapBackground() {
        dismiss()
    }
    
    private func dismiss() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0
        }, completion: { _ in
            self.removeFromSuperview()
        })
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        amountErrorLabel.text = ""
        amountErrorLabel.isHidden = true
        return true
    }
}
