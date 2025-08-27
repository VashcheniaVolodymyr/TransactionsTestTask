//
//  MainScene.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 23.08.2025.
//

import UIKit
import Combine

final class MainScene<ViewModel: MainSceneVMP>: BaseViewController {
    // MARK: Injection
    @Injected private var analyticsService: AnalyticsServiceImpl
    
    // MARK: Private
    private let viewModel: ViewModel
    private var cancellables: Set<AnyCancellable> = []
    
    private lazy var dataSource = CombineTableViewDataSource<String, Transaction> { table, indexPath, transaction in
        let cell = table.dequeueCell(with: TransactionCell.self, for: indexPath)
        cell.selectionStyle = .none
        cell.configure(with: transaction)
        return cell
    }
    
    // MARK: - UI
    private func setupNavBar() {
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.darkText]
        
        navigationItem.title = "OBRIO wallet"
        navigationItem.titleView?.tintColor = UIColor.darkText
    }
    
    private lazy var rateLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 17, weight: .medium)
        label.textColor = .label
        return label
    }()
    
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
            view.heightAnchor.constraint(equalToConstant: 100),
            vStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            vStack.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            depositButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            depositButton.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
        
        return view
    }()
    
    private lazy var depositButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: "plus"), for: .normal)
        button.tintColor = UIColor(resource: .brand)
        button.backgroundColor = .white
        button.layer.cornerRadius = 12
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(didTapDeposit), for: .touchUpInside)
        return button
    }()
    
    private lazy var tableHeaderContainer: UIView = {
        let container = UIView()
        
        container.addSubview(rateLabel)
        rateLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            rateLabel.topAnchor.constraint(equalTo: container.topAnchor, constant: 16),
            rateLabel.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -16)
        ])
        

        container.addSubview(balanceCard)
        balanceCard.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            balanceCard.topAnchor.constraint(equalTo: rateLabel.bottomAnchor, constant: 16),
            balanceCard.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            balanceCard.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            balanceCard.heightAnchor.constraint(equalToConstant: 100)
        ])
        
        container.addSubview(addTransactionButton)
        addTransactionButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            addTransactionButton.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            addTransactionButton.topAnchor.constraint(equalTo: balanceCard.bottomAnchor, constant: 16),
            addTransactionButton.heightAnchor.constraint(equalToConstant: 50)
        ])
        
        container.frame = CGRect(
            x: 0,
            y: 0,
            width: UIScreen.main.bounds.width,
            height: 16 + 20 + 16 + 100 + 16 + 50
        )
        
        return container
    }()
    
    private lazy var addTransactionButton: UIButton = {
        var configuration = UIButton.Configuration.plain()
        configuration.title = "Add transaction"
        configuration.image = UIImage(systemName: "bag.badge.plus")
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        configuration.baseForegroundColor = .black
        configuration.background.backgroundColor = .clear
        configuration.background.strokeColor = .black
        configuration.background.strokeWidth = 1
        configuration.cornerStyle = .large
        
        let button = UIButton(type: .system)
        button.configuration = configuration
        button.addTarget(self, action: #selector(didTapAddTransaction), for: .touchUpInside)
        
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
    
    // MARK: Actions
    @objc private func didTapDeposit() {
        let popup = DepositPopup()
        popup.onConfirm = { [weak self] amount in
            self?.viewModel.deposit(amount: amount)
        }
        popup.onCancel = {
            print("Deposit cancelled")
        }
        popup.show(in: self.view)
        
        analyticsService.trackEvent(name: .tapToDeposit)
    }
    
    @objc private func didTapAddTransaction() {
        viewModel.didTapAddTransaction()
        analyticsService.trackEvent(name: .tapToAddTransaction)
    }
    
    // MARK: - Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        
        viewModel.rate
            .receive(on: DispatchQueue.main)
            .sink { [weak self] rate in
                self?.rateLabel.text = "1₿ = \(rate) USD"
            }
            .store(in: &cancellables)
        
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
        
        dataSource.onLoadNextPage = {
            DispatchQueue.global(qos: .utility).async { [weak self] in
                self?.viewModel.loadNextPageOfHistory()
            }
        }
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
        

        balanceCard.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: 100)
        tableView.tableHeaderView = tableHeaderContainer
        tableView.register(EmptyTableViewCell.self, forCellReuseIdentifier: EmptyTableViewCell.identifier)
        
        view.addSubview(tableView)
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
}
