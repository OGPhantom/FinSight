//
//  TransactionSorting.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionSorting {
    var order: SortOrder = .descending

    mutating func toggleOrder() {
        order = order == .ascending ? .descending : .ascending
    }

    var title: String {
        switch order {
        case .descending:
            return "Newest first"
        case .ascending:
            return "Oldest first"
        }
    }

    func apply(to transactions: [Transaction]) -> [Transaction] {
        transactions.sorted {
            order == .ascending ? $0.date < $1.date : $0.date > $1.date
        }
    }
}
