//
//  EditTransactionSheet.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct EditTransactionSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    var transaction: Transaction

    @State private var merchant: String
    @State private var amountString: String
    @State private var date: Date
    @State private var category: Category
    @State private var notes: String

    init(transaction: Transaction) {
        self.transaction = transaction
        _merchant = State(initialValue: transaction.merchant)
        _amountString = State(initialValue: String(transaction.amount))
        _date = State(initialValue: transaction.date)
        _category = State(initialValue: transaction.category)
        _notes = State(initialValue: transaction.notes ?? "")
    }

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Merchant", text: $merchant)
                    TextField("Amount", text: $amountString)
                        .keyboardType(.decimalPad)

                    DatePicker("Date", selection: $date, displayedComponents: [.date])

                    ZStack {
                        CategoryIcon(category: category)

                        Picker("Category", selection: $category) {
                            ForEach(Category.allCases) { category in
                                Text(category.displayName).tag(category)
                            }
                        }
                    }
                }

                Section("Notes") {
                    TextField("Optional", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Edit Transaction")
            .toolbar { toolbar }
        }
    }
}

private extension EditTransactionSheet {
    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .cancellationAction) {
                Button {
                    dismiss()
                } label: {
                    Text("Cancel")
                        .font(.system(size: 18, weight: .semibold))
                }
            }

            ToolbarItem(placement: .confirmationAction) {
                Button {
                    updateTransaction()
                } label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold))
                }
            }
        }
    }
}

private extension EditTransactionSheet {
    private func updateTransaction() {
        guard let amount = Double(amountString), amount >= 0 else { return }

        transaction.merchant = merchant
        transaction.amount = amount
        transaction.date = date
        transaction.category = category
        transaction.notes = notes.isEmpty ? nil : notes

        try? modelContext.save()
        dismiss()
    }
}
