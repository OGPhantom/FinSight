//
//  TransactionCategoryPickerSheet.swift
//  FinSight
//
//  Created by OpenAI on 03.04.2026.
//

import SwiftUI

struct TransactionCategoryPickerSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsStore.self) private var settings

    @Binding var selection: Category

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 10) {
                    ForEach(Category.allCases) { category in
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
    func categoryRow(_ category: Category) -> some View {
        let isSelected = selection == category
        let accent = category.iconInfo.color

        return Button {
            withAnimation(.spring(response: 0.26, dampingFraction: 0.9)) {
                selection = category
            }
            dismiss()
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(accent.opacity(0.14))

                    Image(systemName: category.iconInfo.symbol)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(accent)
                }
                .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 3) {
                    Text(category.displayName)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)
                }

                Spacer(minLength: 12)

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
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(
                RoundedRectangle(cornerRadius: 22, style: .continuous)
                    .fill(Color(.systemBackground).opacity(0.9))
                    .overlay(
                        RoundedRectangle(cornerRadius: 22, style: .continuous)
                            .stroke(isSelected ? settings.appAccentColor.color.opacity(0.24) : Color.primary.opacity(0.06), lineWidth: 1)
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    TransactionCategoryPickerSheet(selection: .constant(.dining))
        .environment(SettingsStore())
}
