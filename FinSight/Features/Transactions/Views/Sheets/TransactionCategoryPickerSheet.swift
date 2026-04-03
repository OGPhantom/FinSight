//
//  TransactionCategoryPickerSheet.swift
//  FinSight
//
//  Created by OpenAI on 03.04.2026.
//

import SwiftUI
import SwiftData

struct TransactionCategoryPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsStore.self) private var settings
    @Query(sort: \TransactionCategory.sortIndex) private var categories: [TransactionCategory]

    @Binding var selection: TransactionCategory?

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    noCategoryRow

                    ForEach(categories) { category in
                        categoryRow(category)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 24)
            }
            .background(AppBackground())
            .navigationTitle("Choose Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
            }
        }
    }
}

private extension TransactionCategoryPickerSheet {
    var noCategoryRow: some View {
        let isSelected = selection == nil

        return Button {
            withAnimation(.spring(response: 0.26, dampingFraction: 0.9)) {
                selection = nil
            }
            dismiss()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.secondary.opacity(0.12))

                    Image(systemName: "tag.slash.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(.secondary)
                }
                .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 3) {
                    Text("No category")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text("Keep this expense uncategorized")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                selectionMark(isSelected: isSelected)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(rowBackground(isSelected: isSelected))
        }
        .buttonStyle(.plain)
    }

    func categoryRow(_ category: TransactionCategory) -> some View {
        let isSelected = selection?.id == category.id

        return Button {
            withAnimation(.spring(response: 0.26, dampingFraction: 0.9)) {
                selection = category
            }
            dismiss()
        } label: {
            HStack(spacing: 14) {
                CategoryIcon(category: category, size: 42)

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(category.isSystem ? "Default category" : "Custom category")
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                selectionMark(isSelected: isSelected)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(rowBackground(isSelected: isSelected))
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func selectionMark(isSelected: Bool) -> some View {
        if isSelected {
            Image(systemName: "checkmark")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(settings.appAccentColor.color)
                .frame(width: 28, height: 28)
                .background(
                    Circle()
                        .fill(settings.appAccentColor.color.opacity(0.14))
                )
        }
    }

    func rowBackground(isSelected: Bool) -> some View {
        RoundedRectangle(cornerRadius: 22, style: .continuous)
            .fill(Color(.systemBackground).opacity(0.9))
            .overlay(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .stroke(
                        isSelected ? settings.appAccentColor.color.opacity(0.24) : Color.primary.opacity(0.06),
                        lineWidth: 1
                    )
            )
    }
}
