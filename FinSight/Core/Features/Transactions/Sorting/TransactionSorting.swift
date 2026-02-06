//
//  TransactionSorting.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionSorting {
    var sort: TransactionSort = .date
    var order: SortOrder = .descending

    mutating func toggle(_ option: TransactionSort) {
        if sort == option {
            order = order == .ascending ? .descending : .ascending
        } else {
            sort = option
            order = .ascending
        }
    }

    func icon(for option: TransactionSort) -> String {
        guard sort == option else { return "" }
        return order == .ascending ? "arrow.up" : "arrow.down"
    }

    func apply(to transactions: [Transaction]) -> [Transaction] {
        transactions.sorted {
            switch sort {
            case .date:
                order == .ascending ? $0.date < $1.date : $0.date > $1.date
            case .amount:
                order == .ascending ? $0.amount < $1.amount : $0.amount > $1.amount
            case .merchant:
                order == .ascending ? $0.merchant < $1.merchant : $0.merchant > $1.merchant
            }
        }
    }
}
