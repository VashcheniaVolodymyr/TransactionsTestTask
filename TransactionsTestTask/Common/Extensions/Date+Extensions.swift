//
//  Date+Extensions.swift
//  TransactionsTestTask
//
//  Created by Vashchenia Volodymyr on 27.08.2025.
//

import Foundation

extension Date {
    func dateString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMM dd yyyy"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
    
    func timeString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = Locale.current
        return formatter.string(from: self)
    }
}
