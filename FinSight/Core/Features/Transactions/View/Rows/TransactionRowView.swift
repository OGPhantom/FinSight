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
            CategoryIcon(category: transaction.category)

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
        .padding()
        .background(TransactionRowBackground())
        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }
}

#Preview {
    TransactionRowView(transaction: Transaction.mock)
}
