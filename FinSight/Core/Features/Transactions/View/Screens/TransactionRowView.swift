//
//  TransactionRowView.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionRowView: View {
    var transaction: Transaction
    var body: some View {
        HStack(spacing: 14) {
            CategoryIcon(category: transaction.category)
                .scaleEffect(1.15)

            VStack(alignment: .leading) {
                Text(transaction.merchant)
                    .font(.headline)

                Text(transaction.category.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()
            
            VStack(alignment: .trailing) {
                Text(transaction.amount, format: .currency(code: "USD"))
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.primary)

                Text(transaction.date.formatted(
                    .dateTime
                        .month(.abbreviated)
                        .day(.twoDigits)
                        .year()
                ))
                .font(.caption)
                .foregroundStyle(.secondary.opacity(0.7))
            }
        }
        .modifier(CardRowModifier())
    }
}

#Preview {
    TransactionRowView(transaction: Transaction.mock)
}
