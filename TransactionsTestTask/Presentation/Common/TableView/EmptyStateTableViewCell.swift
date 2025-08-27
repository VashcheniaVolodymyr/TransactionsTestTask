//
//  EmptyStateTableView.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 27.08.2025.
//

import UIKit

final class EmptyTableViewCell: UITableViewCell {
    // MARK: Private
    private let titleLabel = UILabel()
    private let messageLabel = UILabel()
    
    // MARK: Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        selectionStyle = .none
        titleLabel.font = .boldSystemFont(ofSize: 18)
        titleLabel.textAlignment = .center
        messageLabel.font = .systemFont(ofSize: 15)
        messageLabel.textColor = .secondaryLabel
        messageLabel.textAlignment = .center
        messageLabel.numberOfLines = 0
        
        let stack = UIStackView(arrangedSubviews: [titleLabel, messageLabel])
        stack.axis = .vertical
        stack.spacing = 8
        stack.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(stack)
        
        NSLayoutConstraint.activate([
            stack.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            stack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            contentView.heightAnchor.constraint(equalToConstant: 300) // фиксируем высоту
        ])
    }

    required init?(coder: NSCoder) { fatalError() }
    
    // MARK: Public
    func configure(title: String, message: String) {
        titleLabel.text = title
        messageLabel.text = message
    }
}
