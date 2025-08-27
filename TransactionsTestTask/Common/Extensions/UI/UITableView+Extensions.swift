//
//  UITableView+Combine.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 26.08.2025.
//

import UIKit
import Combine

struct TableSection<SectionID: Hashable, Item: Hashable>: Hashable {
    let id: SectionID
    var items: [Item]
}

class CombineTableViewDataSource<SectionID: Hashable, Element: Hashable>: NSObject, UITableViewDataSource, UITableViewDelegate {
    typealias CellBuilder = (UITableView, IndexPath, Element) -> UITableViewCell
    
    private let build: CellBuilder
    private var sections: [TableSection<SectionID, Element>] = []
    
    var onLoadNextPage: (() -> Void)?
    
    private var isLoadingNextPage = false
    
    init(builder: @escaping CellBuilder) {
        build = builder
        super.init()
    }
    
    func pushSections(_ sections: [TableSection<SectionID, Element>], to tableView: UITableView) {
        tableView.dataSource = self
        tableView.delegate = self
        self.sections = sections
        tableView.reloadData()
        isLoadingNextPage = false
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.isEmpty ? 1 : sections.count
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if sections.isEmpty {
            return 1
        } else {
            return sections[section].items.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if sections.isEmpty {
            let cell = tableView.dequeueCell(with: EmptyTableViewCell.self, for: indexPath)
            cell.configure(title: AppConstants.History.noTransactions, message: AppConstants.History.your_history_will_appear_here)
            return cell
        }
        
        let items = sections[indexPath.section].items
        return build(tableView, indexPath, items[indexPath.row])
    }

    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if sections.isEmpty {
            return nil
        } else {
            return String(describing: sections[section].id)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.size.height
        
        if offsetY > contentHeight - frameHeight - 100, !isLoadingNextPage {
            isLoadingNextPage = true
            onLoadNextPage?()
        }
    }
}

extension UITableViewCell {
    static var identifier: String {
        String(describing: self)
    }
}

extension NSObject {
    static var className: String {
        String(describing: self)
    }
}

extension UITableView {
    func dequeueCell<T: UITableViewCell>(withType type: UITableViewCell.Type) -> T {
        return dequeueReusableCell(withIdentifier: type.identifier) as! T
    }
    
    func dequeueCell<T: UITableViewCell>(with type: T.Type, for indexPath: IndexPath) -> T {
        dequeueReusableCell(withIdentifier: type.className, for: indexPath) as! T
    }
}
