//
//  TransactionCell.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 25.08.2025.
//

import UIKit

class TransactionCell: UITableViewCell {
    // MARK: Private
    private var iconBgBottomConstraint: NSLayoutConstraint?
    
    // MARK: - UI
    private let transactionIconImage: UIImageView = {
        let iv = UIImageView()
        iv.image = UIImage(systemName: "fork.knife")
        iv.tintColor = UIColor.black
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let transactionIconBg: UIView = {
        let iv = UIView()
        iv.layer.cornerRadius = 12
        iv.backgroundColor = UIColor(resource: .brand)
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    private let categoryLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let noteLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12, weight: .regular)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let vstackCategoryNoteLabel: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.alignment = .leading
        sv.translatesAutoresizingMaskIntoConstraints = false
        return sv
    }()
    
    private let amountLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14, weight: .regular)
        label.textColor = UIColor.black
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.setupView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: Lifecycle
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCellAppearance()
    }
    
    // MARK: - Private methods
    private func setupView() {
        contentView.backgroundColor = .clear
        
        vstackCategoryNoteLabel.addArrangedSubview(categoryLabel)
        vstackCategoryNoteLabel.addArrangedSubview(noteLabel)
        
        contentView.addSubview(transactionIconBg)
        contentView.addSubview(transactionIconImage)
        contentView.addSubview(vstackCategoryNoteLabel)
        contentView.addSubview(amountLabel)
        
        iconBgBottomConstraint = transactionIconBg.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        
        NSLayoutConstraint.activate([
            transactionIconBg.widthAnchor.constraint(equalToConstant: 40),
            transactionIconBg.heightAnchor.constraint(equalToConstant: 40),
            transactionIconBg.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 15),
            transactionIconBg.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            iconBgBottomConstraint!,
            
            transactionIconImage.centerYAnchor.constraint(equalTo: transactionIconBg.centerYAnchor),
            transactionIconImage.centerXAnchor.constraint(equalTo: transactionIconBg.centerXAnchor),
            
            vstackCategoryNoteLabel.centerYAnchor.constraint(equalTo: transactionIconBg.centerYAnchor),
            vstackCategoryNoteLabel.leadingAnchor.constraint(equalTo: transactionIconBg.trailingAnchor, constant: 10),
            
            amountLabel.centerYAnchor.constraint(equalTo: transactionIconBg.centerYAnchor),
            amountLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
        ])
        
    }
    
    private func resetCellAppearance() {
        self.layer.cornerRadius = 0
        self.clipsToBounds = false
        self.layer.maskedCorners = []
        iconBgBottomConstraint?.constant = 0
    }
    
    // MARK: Public
    func configure(with transaction: Transaction) {
        switch transaction.type {
        case .deposit:
            self.categoryLabel.text = "Deposit"
            self.transactionIconImage.image = UIImage(systemName: "plus")
            self.transactionIconImage.tintColor = .white
            self.transactionIconBg.backgroundColor = UIColor(resource: .brand)
            self.transactionIconBg.layer.borderWidth = 0
            self.transactionIconBg.layer.borderColor = UIColor.clear.cgColor
        case .withdrawal:
            self.categoryLabel.text = transaction.category?.rawValue.capitalized
            self.transactionIconImage.image = transaction.category?.icon
            self.transactionIconBg.backgroundColor = UIColor.clear
            self.transactionIconBg.layer.borderWidth = 1
            self.transactionIconBg.layer.borderColor = UIColor.black.cgColor
            self.transactionIconImage.tintColor = .black
        case .undefined(let undefined):
            self.categoryLabel.text = undefined
            self.transactionIconImage.image = Transaction.Category.other.icon
            self.transactionIconImage.tintColor = .black
            self.transactionIconBg.backgroundColor = .clear
            self.transactionIconBg.layer.borderWidth = 1
            self.transactionIconBg.layer.borderColor = UIColor.black.cgColor
        }

        let sign = transaction.type == .withdrawal ? "-" : ""
        self.amountLabel.text = sign + "\(transaction.amount)"
        
        amountLabel.textColor = UIColor.darkText
        noteLabel.text = transaction.createdAt.timeString()
    }
}
