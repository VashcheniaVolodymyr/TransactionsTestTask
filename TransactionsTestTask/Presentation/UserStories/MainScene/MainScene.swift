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
    
    lazy var dataSource = CombineTableViewDataSource<String, Transaction> { table, indexPath, transaction in
        let cell = table.dequeueCell(with: TransactionCell.self, for: indexPath)
        cell.configure(with: transaction)
        return cell
    }
    
    // MARK: - UI
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        
        navigationItem.title = "OBRIO Wallet"
        navigationItem.titleView?.tintColor = UIColor.darkText
    }
    
    private lazy var balanceLabel: UILabel = {
        let label = UILabel()
        label.font = .boldSystemFont(ofSize: 28)
        label.textColor = .label
        return label
    }()
    
    private lazy var balanceCard: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(resource: .brand)
        view.layer.cornerRadius = 20
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOpacity = 0.15
        view.layer.shadowRadius = 8
        
        let btcLabel = UILabel()
        btcLabel.text = "Balance"
        btcLabel.font = .systemFont(ofSize: 14, weight: .medium)
        btcLabel.textColor = .white
        
        balanceLabel.font = .boldSystemFont(ofSize: 32)
        balanceLabel.textColor = .white
        
        let vStack = UIStackView(arrangedSubviews: [btcLabel, balanceLabel])
        vStack.axis = .vertical
        vStack.spacing = 4
        
        view.addSubview(vStack)
        view.addSubview(depositButton)
        
        vStack.translatesAutoresizingMaskIntoConstraints = false
        depositButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            depositButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            depositButton.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            view.heightAnchor.constraint(equalToConstant: 100)
        ])
                
        return view
    }()
    
    private lazy var depositButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus.app.fill"), for: .normal)
        button.tintColor = .white
        button.backgroundColor = UIColor(resource: .brand)
        button.layer.cornerRadius = 12
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(didTapDeposit), for: .touchUpInside)
        return button
    }()
    
    private lazy var headerStack: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [balanceCard, addTransactionButton])
        stack.axis = .horizontal
        stack.alignment = .center
        return stack
    }()
    
    private lazy var addTransactionButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add transaction", for: .normal)
        button.titleLabel?.font = .boldSystemFont(ofSize: 18)
        button.backgroundColor = .systemGray6
        button.layer.cornerRadius = 12
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.addTarget(self, action: #selector(didTapAddTransaction), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.separatorStyle = .none
        table.showsVerticalScrollIndicator = false
        table.backgroundColor = .none
        table.register(TransactionCell.self, forCellReuseIdentifier: TransactionCell.identifier)
        table.sectionHeaderTopPadding = 0
        table.translatesAutoresizingMaskIntoConstraints = false
        return table
    }()
    
    private func setupLayout() {
        let stack = UIStackView(arrangedSubviews: [headerStack, tableView])
        stack.axis = .vertical
        stack.spacing = 16
        view.addSubview(stack)
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            stack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            stack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            stack.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    @objc private func didTapDeposit() {
        let alert = UIAlertController(title: "Deposit BTC", message: "Enter amount", preferredStyle: .alert)
        alert.addTextField { tf in tf.keyboardType = .decimalPad }
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel))
        alert.addAction(UIAlertAction(title: "OK", style: .default) { [weak self] _ in
            if let text = alert.textFields?.first?.text, let amount = Double(text) {
                self?.viewModel.deposit(amount: amount)
            }
        })
        present(alert, animated: true)
    }
    
    @objc private func didTapAddTransaction() {
        viewModel.didTapAddTransaction()
    }
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.balance
            .receive(on: DispatchQueue.main)
            .sink { [weak self] btc in
                self?.balanceLabel.text = "₿ \(btc)"
            }
            .store(in: &cancellables)
        
        viewModel.historySections
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] sections in
                guard let self = self else { return }
                self.dataSource.pushSections(sections, to: self.tableView)
            }).store(in: &cancellables)
        
        viewModel.rate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                self?.navigationItem.rightBarButtonItem?.title = "1 BTC = $\(rate)"
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
        setupNavBar()
        view.backgroundColor = .white
        
        setupLayout()
    }
}
