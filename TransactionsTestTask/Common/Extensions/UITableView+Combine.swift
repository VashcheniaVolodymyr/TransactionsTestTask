//
//  UITableView+Combine.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 26.08.2025.
//

import UIKit
import Combine

// MARK: - Section model
struct TableSection<SectionID: Hashable, Item> {
    let id: SectionID
    var items: [Item]
}

// MARK: - DataSource
class CombineTableViewDataSource<SectionID: Hashable, Element>: NSObject, UITableViewDataSource {
    typealias CellBuilder = (UITableView, IndexPath, Element) -> UITableViewCell
    
    private let build: CellBuilder
    private var sections: [TableSection<SectionID, Element>] = []
    
    init(builder: @escaping CellBuilder) {
        build = builder
        super.init()
    }
    
    // MARK: - Push elements (старый API)
    func pushElements(_ elements: [Element], to tableView: UITableView) {
        tableView.dataSource = self
        self.sections = [TableSection(id: "default" as! SectionID, items: elements)]
        tableView.reloadData()
    }
    
    // MARK: - Push sections (новый API)
    func pushSections(_ sections: [TableSection<SectionID, Element>], to tableView: UITableView) {
        tableView.dataSource = self
        self.sections = sections
        tableView.reloadData()
    }
    
    // MARK: - UITableViewDataSource
    func numberOfSections(in tableView: UITableView) -> Int {
        sections.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sections[section].items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = sections[indexPath.section].items[indexPath.row]
        return build(tableView, indexPath, item)
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        String(describing: sections[section].id)
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
