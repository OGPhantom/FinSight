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
    @Environment(SettingsStore.self) private var settings
    @Query(sort: \TransactionCategory.sortIndex) private var categories: [TransactionCategory]

    @State private var amountString: String = ""
    @State private var date: Date = .now
    @State private var merchant: String = ""
    @State private var selectedCategory: TransactionCategory?
    @State private var notes: String = ""
    @State private var showingCategoryPicker = false

    @FocusState private var focusedField: Field?

    private enum Field {
        case amount
        case merchant
        case notes
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    amountSurface
                    compactMetaSurface
                    notesSurface
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .background(AppBackground())
            .navigationTitle("Add Expense")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar { toolbar }
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
            .sheet(isPresented: $showingCategoryPicker) {
                TransactionCategoryPickerSheet(selection: $selectedCategory)
                    .environment(settings)
            }
            .onAppear {
                if selectedCategory == nil {
                    selectedCategory = categories.first(where: { $0.legacyKey == Category.other.rawValue }) ?? categories.first
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                    focusedField = .amount
                }
            }
        }
    }
}

private extension AddTransactionSheet {
    var normalizedAmountString: String {
        amountString.replacingOccurrences(of: ",", with: ".")
    }

    var parsedAmount: Double? {
        Double(normalizedAmountString)
    }

    var trimmedMerchant: String {
        merchant.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var trimmedNotes: String {
        notes.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    var isSaveEnabled: Bool {
        guard let amount = parsedAmount, amount > 0 else { return false }
        return !trimmedMerchant.isEmpty
    }

    var amountSurface: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("AMOUNT")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(0.8)

            HStack(alignment: .firstTextBaseline, spacing: 10) {
                TextField("0", text: $amountString)
                    .keyboardType(.decimalPad)
                    .focused($focusedField, equals: .amount)
                    .font(.system(size: 46, weight: .bold, design: .rounded))
                    .foregroundStyle(.primary)

                Text(settings.currencyCode)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .padding(.horizontal, 10)
                    .padding(.vertical, 6)
                    .background(
                        Capsule(style: .continuous)
                            .fill(Color.primary.opacity(0.06))
                    )
            }

            Divider()
                .overlay(Color.primary.opacity(0.08))
        }
        .padding(20)
        .background(surfaceBackground)
    }

    var compactMetaSurface: some View {
        VStack(spacing: 10) {
            compactFieldRow(
                label: "Merchant",
                icon: "storefront.fill",
                tint: settings.appAccentColor.color
            ) {
                TextField("Where did you spend?", text: $merchant)
                    .focused($focusedField, equals: .merchant)
                    .textInputAutocapitalization(.words)
                    .autocorrectionDisabled()
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.primary)
                    .multilineTextAlignment(.trailing)
            }

            compactButtonRow(
                label: "Category",
                value: selectedCategory?.name ?? "No category",
                icon: selectedCategory?.snapshot.resolvedIconName ?? "tag.fill",
                tint: selectedCategory?.color ?? .gray
            ) {
                showingCategoryPicker = true
            }

            compactFieldRow(
                label: "Date",
                icon: "calendar",
                tint: .teal
            ) {
                DatePicker("", selection: $date, displayedComponents: .date)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(settings.appAccentColor.color)
                    .scaleEffect(x: 0.98, y: 0.98, anchor: .trailing)
            }

            compactFieldRow(
                label: "Time",
                icon: "clock.fill",
                tint: .orange
            ) {
                DatePicker("", selection: $date, displayedComponents: .hourAndMinute)
                    .labelsHidden()
                    .datePickerStyle(.compact)
                    .tint(settings.appAccentColor.color)
                    .scaleEffect(x: 0.98, y: 0.98, anchor: .trailing)
            }
        }
        .padding(12)
        .background(surfaceBackground)
    }

    var notesSurface: some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                miniIcon(symbol: "note.text", tint: .indigo)

                VStack(alignment: .leading, spacing: 2) {
                    Text("Notes")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text("Optional context for search and reports.")
                        .font(.system(size: 12))
                        .foregroundStyle(.secondary)
                }
            }

            ZStack(alignment: .topLeading) {
                if notes.isEmpty {
                    Text("Add a note if this expense needs context...")
                        .font(.system(size: 15))
                        .foregroundStyle(.secondary)
                        .padding(.top, 14)
                        .padding(.leading, 14)
                }

                TextEditor(text: $notes)
                    .focused($focusedField, equals: .notes)
                    .scrollContentBackground(.hidden)
                    .frame(minHeight: 112)
                    .font(.system(size: 15))
                    .foregroundStyle(.primary)
                    .tint(settings.appAccentColor.color)
                    .padding(8)
            }
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color.primary.opacity(0.035))
                    .overlay(
                        RoundedRectangle(cornerRadius: 20, style: .continuous)
                            .stroke(Color.primary.opacity(0.08), lineWidth: 1)
                    )
            )
        }
        .padding(20)
        .background(surfaceBackground)
    }

    var toolbar: some ToolbarContent {
        ToolbarItem(placement: .cancellationAction) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 17, weight: .bold))
                    .foregroundStyle(.primary)
            }
        }
    }

    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color.primary.opacity(0.06))

            Button {
                saveTransaction()
            } label: {
                Text("CREATE")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(isSaveEnabled ? settings.appAccentColor.color : Color.primary.opacity(0.14))
                    )
                    .foregroundStyle(isSaveEnabled ? .white : .secondary)
            }
            .buttonStyle(.plain)
            .disabled(!isSaveEnabled)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
    }

    var surfaceBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(Color(.systemBackground).opacity(0.9))
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: Color.black.opacity(0.05), radius: 12, x: 0, y: 6)
    }

    @ViewBuilder
    func compactFieldRow<Content: View>(
        label: String,
        icon: String,
        tint: Color,
        @ViewBuilder trailing: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            miniIcon(symbol: icon, tint: tint)

            Text(label)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer(minLength: 12)

            trailing()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.primary.opacity(0.035))
        )
    }

    func compactButtonRow(
        label: String,
        value: String,
        icon: String,
        tint: Color,
        action: @escaping () -> Void
    ) -> some View {
        Button(action: action) {
            HStack(spacing: 12) {
                miniIcon(symbol: icon, tint: tint)

                Text(label)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(.primary)

                Spacer(minLength: 12)

                Text(value)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .bold))
                    .foregroundStyle(.secondary.opacity(0.8))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 18, style: .continuous)
                    .fill(Color.primary.opacity(0.035))
            )
        }
        .buttonStyle(.plain)
    }

    func miniIcon(symbol: String, tint: Color) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .fill(tint.opacity(0.14))

            Image(systemName: symbol)
                .font(.system(size: 14, weight: .bold))
                .foregroundStyle(tint)
        }
        .frame(width: 34, height: 34)
    }

    func saveTransaction() {
        guard let amount = parsedAmount, amount > 0 else { return }

        let notesValue: String? = trimmedNotes.isEmpty ? nil : trimmedNotes
        let transaction = Transaction(
            id: UUID(),
            amount: amount,
            date: date,
            merchant: trimmedMerchant,
            category: Category(rawValue: selectedCategory?.legacyKey ?? "") ?? .other,
            linkedCategory: selectedCategory,
            notes: notesValue
        )

        do {
            modelContext.insert(transaction)
            try modelContext.save()
            dismiss()
        } catch {
            print("Failed to save transaction: \(error)")
        }
    }
}

#Preview {
    AddTransactionSheet()
        .environment(SettingsStore())
}
