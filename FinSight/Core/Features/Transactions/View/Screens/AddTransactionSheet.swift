//
//  AddTransactionSheet.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct AddTransactionSheet: View {
    @Environment(\.dismiss) private var dismiss
    @State private var amountString: String = ""
    @State private var date: Date = .now
    @State private var merchant: String = ""
    @State private var category: Transaction.Category = .other
    @State private var isSubscription: Bool = false
    @State private var notes: String = ""

    var body: some View {
        NavigationStack {
            Form {
                Section("Details") {
                    TextField("Merchant", text: $merchant)
                    TextField("Amount", text: $amountString)
                        .keyboardType(.decimalPad)

                    DatePicker("Date", selection: $date, displayedComponents: [.date])

                    Picker("Category", selection: $category) {
                        ForEach(Transaction.Category.allCases) { category in
                            Text(category.displayName).tag(category)
                        }
                    }

                    Toggle("Subscription", isOn: $isSubscription)

                }

                Section("Notes") {
                    TextField("Optional", text: $notes, axis: .vertical)
                        .lineLimit(3, reservesSpace: true)
                }
            }
            .navigationTitle("Add Transaction")
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(.red)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.red.opacity(0.12)))
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button {
                        //
                    } label: {
                        Text("Done")
                            .font(.system(size: 18, weight: .semibold))
                            .foregroundStyle(Color.accentColor)
                            .padding(.horizontal, 14)
                            .padding(.vertical, 6)
                            .background(
                                Capsule()
                                    .fill(Color.accentColor.opacity(0.12))
                            )
                    }
                    .disabled(!isSaveEnabled)
                }
            }
        }
    }

    private var isSaveEnabled: Bool {
        guard !merchant.trimmingCharacters(in: .whitespaces).isEmpty else { return false }
        guard let amount = Double(amountString), amount > 0 else { return false }
        return true
    }

}

#Preview {
    AddTransactionSheet()
}
