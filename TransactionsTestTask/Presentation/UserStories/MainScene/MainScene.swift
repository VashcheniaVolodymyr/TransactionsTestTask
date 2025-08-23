//
//  MainScene.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import UIKit
import Combine

final class MainScene<ViewModel: MainSceneVMP>: BaseViewController {
    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    // UI elements
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.text = "Total Balance: \(viewModel.balance.value)"
        label.font = .boldSystemFont(ofSize: 24)
        label.textAlignment = .center
        return label
    }()
    
    private lazy var mainStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [balanceLabel])
        stack.axis = .vertical
        stack.spacing = 16
        return stack
    }()
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.balance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] newBalance in
                self?.balanceLabel.text = "Total Balance: \(newBalance)"
            }
            .store(in: &cancellables)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDidLoad()
        view.backgroundColor = .red
        
        setupLayout()
    }
    
    private func setupLayout() {
        view.addSubview(mainStack)
        mainStack.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            mainStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            mainStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            mainStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            mainStack.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -16)
        ])
    }
}
