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
        guard !searchQuery.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else {
            return transactions
        }

        let query = searchQuery.lowercased()

        return transactions
            .compactMap { transaction -> (Transaction, Int)? in
                var score = 0

                // Merchant
                if transaction.merchant.localizedCaseInsensitiveContains(query) {
                    score += 3
                }

                // Notes
                if transaction.notes?.localizedCaseInsensitiveContains(query) == true {
                    score += 2
                }

                // Category
                if transaction.displayCategoryName.localizedCaseInsensitiveContains(query) {
                    score += 2
                }

                // Exact match
                if transaction.merchant.lowercased() == query {
                    score += 5
                }

                return score > 0 ? (transaction, score) : nil
            }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
    }
}
