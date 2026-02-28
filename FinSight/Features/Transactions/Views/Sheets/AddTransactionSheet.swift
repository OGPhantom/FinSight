//
//  AddTransactionSheet.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI
import SwiftData

struct AddTransactionSheet: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var amountString: String = ""
    @State private var date: Date = .now
    @State private var merchant: String = ""
    @State private var category: Category = .other
    @State private var notes: String = ""

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
            .navigationTitle("Add Transaction")
            .toolbar { toolbar }
        }
    }
}

private extension AddTransactionSheet {
    private var normalizedAmountString: String {
        amountString.replacingOccurrences(of: ",", with: ".")
    }

    private var isSaveEnabled: Bool {
        guard !merchant.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard let amount = Double(normalizedAmountString), amount > 0 else { return false }
        return true
    }

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
                    saveTransaction()
                } label: {
                    Text("Done")
                        .font(.system(size: 18, weight: .semibold))
                }
                .disabled(!isSaveEnabled)
            }
        }
    }
}

private extension AddTransactionSheet {
    func saveTransaction() {
        guard let amount = Double(normalizedAmountString), amount >= 0 else { return }

        let trimmedNotes = notes.trimmingCharacters(in: .whitespacesAndNewlines)
        let notesValue: String? = trimmedNotes.isEmpty ? nil : trimmedNotes

        let transaction = Transaction(
            id: UUID(), amount: amount, date: date, merchant: merchant, category: category, notes: notesValue
        )

        modelContext.insert(transaction)
        dismiss()
    }
}

#Preview {
    AddTransactionSheet()
}
