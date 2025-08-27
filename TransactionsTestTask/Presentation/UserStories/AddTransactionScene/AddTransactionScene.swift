//
//  AddTransactionScene.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 26.08.2025.
//
import UIKit
import Combine

final class AddTransactionScene<ViewModel: AddTransactionSceneVMP>: BaseViewController, UITextFieldDelegate {
    // MARK: Private
    private let viewModel: ViewModel
    private var addButtonBottomConstraint: NSLayoutConstraint!
    private var cancellables: Set<AnyCancellable> = []
    
    // MARK: UI
    private let amountField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "0.00"
        textField.borderStyle = .roundedRect
        textField.keyboardType = .decimalPad
        
        textField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return textField
    }()
    
    private let amountErrorLabel: UILabel = {
        let label = UILabel()
        label.textColor = .systemRed
        label.font = .systemFont(ofSize: 13)
        label.numberOfLines = 0
        label.text = " "
        label.alpha = 1
        return label
    }()
    
    private let categorySegment: UISegmentedControl = {
        let segment = UISegmentedControl(items: Transaction.Category.allCases.map { $0.rawValue.capitalized })
        segment.selectedSegmentIndex = 0
        
        segment.selectedSegmentTintColor = UIColor(resource: .brand)
        segment.backgroundColor = UIColor.white
        
        let normalAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.systemGray,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        let selectedAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white,
            .font: UIFont.systemFont(ofSize: 14, weight: .medium)
        ]
        segment.setTitleTextAttributes(normalAttributes, for: .normal)
        segment.setTitleTextAttributes(selectedAttributes, for: .selected)

        segment.layer.cornerRadius = 8
        segment.layer.masksToBounds = true
        segment.apportionsSegmentWidthsByContent = true
        return segment
    }()
    
    private let addButton: UIButton = {
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Add"
        configuration.image = UIImage(systemName: "bag.badge.plus")
        configuration.imagePadding = 8
        configuration.contentInsets = NSDirectionalEdgeInsets(top: 8, leading: 16, bottom: 8, trailing: 16)
        configuration.baseForegroundColor = .white
        configuration.background.backgroundColor = UIColor(resource: .brand)
        configuration.cornerStyle = .large
        
        let button = UIButton(type: .system)
        button.configuration = configuration
        
        button.heightAnchor.constraint(equalToConstant: 56).isActive = true
        
        return button
    }()
    
    // MARK: Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bindKeyboard(to: addButtonBottomConstraint, extraOffset: 16)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if amountField.canBecomeFirstResponder {
            self.amountField.becomeFirstResponder()
        }
    }
    
    // MARK: Init
    init(viewModel: ViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.amountField.delegate = self
        
        viewModel.fieldError
            .sink { [weak self] error in
                guard let self = self else { return }
                
                if error.isNil {
                    self.amountErrorLabel.text = ""
                    self.amountErrorLabel.alpha = 0
                } else {
                    self.amountErrorLabel.text = error
                    self.amountErrorLabel.alpha = 1
                }
            }
            .store(in: &cancellables)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Private methods
    private func setupUI() {
        title = "Add Transaction"
        view.backgroundColor = .systemBackground
        
        let formStack = UIStackView(arrangedSubviews: [amountField, amountErrorLabel, categorySegment])
        formStack.axis = .vertical
        formStack.spacing = 8
        formStack.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(formStack)
        view.addSubview(addButton)
        
        addButton.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButtonBottomConstraint = addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -20)
        
        NSLayoutConstraint.activate([
            formStack.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 40),
            formStack.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            formStack.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addButton.heightAnchor.constraint(equalToConstant: 50),
            addButtonBottomConstraint
        ])
    }
    
    // MARK: Action
    @objc private func addTapped() {
        let selectedCategory = Transaction.Category.allCases[categorySegment.selectedSegmentIndex]
        viewModel.addTransaction(amount: amountField.text ?? "", category: selectedCategory)
    }
    
    // MARK: UITextFieldDelegate
    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        viewModel.amoudDidChanged()
        return true
    }
}
