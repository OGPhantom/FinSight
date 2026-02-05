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
        HStack {
            Image(systemName: "circle.fill")

            VStack(alignment: .leading) {
                Text(transaction.merchant)
                    .font(.headline)

                Text(transaction.category.displayName)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }

            Spacer()

            VStack(alignment: .trailing) {
                Text("$\(transaction.amount)")
                    .font(.headline)

                Text(transaction.date.formatted())
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
    }
}

#Preview {
    TransactionRowView(transaction: Transaction.mock)
}
