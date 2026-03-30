//
//  TransactionViewModel.swift
//  FinSight
//
//  Created by Никита Сторчай on 21.03.2026.
//

import Foundation

@Observable
final class TransactionViewModel {
    var searchQuery: String = ""

    func filteredTransactions(transactions: [Transaction]) -> [Transaction] {
        guard !searchQuery.isEmpty else { return transactions }
        let query = searchQuery.lowercased()
        return transactions.filter { transaction in
            let notesMatch = transaction.notes?.localizedCaseInsensitiveContains(query) ?? false
            let titleMatch = transaction.merchant.lowercased().contains(query)
            return notesMatch || titleMatch
        }
    }
}
