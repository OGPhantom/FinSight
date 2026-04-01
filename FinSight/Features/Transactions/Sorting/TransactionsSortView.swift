//
//  TransactionsSortView.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionsSortView: View {
    @Environment(SettingsStore.self) private var settings
    @Binding var sorting: TransactionSorting
    
    var body: some View {
        HStack(alignment: .center, spacing: 14) {
            SectionTitle(text: "Order")
            
            Spacer(minLength: 8)
            
            sortingButton
        }
        .padding(16)
        .background(CardBackground(cornerRadius: 20))
    }
}


private extension TransactionsSortView {
    private var sortingButton: some View {
        HStack(spacing: 10) {
            Button {
                sorting.toggleOrder()
            } label: {
                Text(sorting.order.title)
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
}
#Preview {
    TransactionsSortView(sorting: .constant(TransactionSorting(order: .ascending)))
        .environment(SettingsStore())
}
