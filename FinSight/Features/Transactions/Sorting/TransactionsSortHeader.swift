//
//  TransactionsSortHeader.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionsSortHeader: View {
    @Environment(SettingsStore.self) private var settings
    @Binding var sorting: TransactionSorting

    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("ORDER")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .tracking(0.8)

//                Text("Keep the journal chronological.")
//                    .font(.subheadline)
//                    .foregroundStyle(.secondary)
            }

            Spacer(minLength: 8)

            HStack(spacing: 10) {
                Button {
                    sorting.toggleOrder()
                } label: {
                    Text(sorting.title)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                        .padding(.horizontal, 14)
                        .padding(.vertical, 10)
                        .background(
                            Capsule()
                                .fill(Color.primary.opacity(0.06))
                        )
                }
                .buttonStyle(.plain)

                Button {
                    sorting.toggleOrder()
                } label: {
                    Image(systemName: sorting.order == .ascending ? "arrow.up" : "arrow.down")
                        .font(.system(size: 14, weight: .bold))
                        .foregroundStyle(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle()
                                .fill(settings.appAccentColor.color.gradient)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
        .background(CardBackground(cornerRadius: 20))
    }
}

#Preview {
    TransactionsSortHeader(sorting: .constant(TransactionSorting(order: .ascending)))
        .environment(SettingsStore())
}
