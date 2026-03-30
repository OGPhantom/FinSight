//
//  SettingsViewModel.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

@Observable
final class SettingsViewModel {
    var totalSpent: Double = 0

    var selectedPeriod: Period = .all

    enum Period {
        case week
        case month
        case all

        var title: String {
            switch self {
            case .week: return "Week"
            case .month: return "Month"
            case .all: return "All time"
            }
        }
    }
    
    func updateTotal(from transactions: [Transaction]) {
        let filtered = filterTransactions(transactions)
        totalSpent = filtered.reduce(0) { $0 + $1.amount }
    }
}

private extension SettingsViewModel {
    func filterTransactions(_ transactions: [Transaction]) -> [Transaction] {
        switch selectedPeriod {
        case .all:
            return transactions

        case .month:
            let calendar = Calendar.current
            let now = Date()
            return transactions.filter {
                calendar.isDate($0.date, equalTo: now, toGranularity: .month)
            }

        case .week:
            let calendar = Calendar.current
            let now = Date()
            return transactions.filter {
                calendar.isDate($0.date, equalTo: now, toGranularity: .weekOfYear)
            }
        }
    }
}
