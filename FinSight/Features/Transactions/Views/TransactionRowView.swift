//
//  TransactionRowView.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionRowView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.colorScheme) private var colorScheme
    
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 14) {
            categoryBadge
            
            transactionInfo
            
            Spacer(minLength: 12)
            
            transactionMeta
        }
        .contentShape(Rectangle())
        .padding(.horizontal, 16)
        .padding(.vertical, 10)
    }
}

private extension TransactionRowView {
    var categoryBadge: some View {
        let info = transaction.category.iconInfo
        
        return ZStack {
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(info.color.opacity(0.14))
            
            CategoryIcon(category: transaction.category)
                .scaleEffect(0.88)
        }
        .frame(width: 44, height: 44)
    }
    
    var transactionInfo: some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(transaction.merchant)
                .font(.system(size: 17, weight: .semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Text(transaction.category.displayName)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(1)
        }
    }
    
    var transactionMeta: some View {
        VStack(alignment: .trailing, spacing: 6) {
            Text(transaction.amount, format: .currency(code: settings.currencyCode))
                .font(.system(size: 18, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
            
            Text(transaction.date.formatted(.dateTime.hour().minute()))
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)
                .padding(.horizontal, 10)
                .padding(.vertical, 6)
                .background(
                    Capsule()
                        .fill(timeBadgeFill)
                )
        }
    }
    
    var timeBadgeFill: AnyShapeStyle {
        if colorScheme == .dark {
            return AnyShapeStyle(Color.white.opacity(0.06))
        }
        
        return AnyShapeStyle(settings.appAccentColor.color.opacity(0.10))
    }
}

#Preview {
    VStack {
        TransactionRowView(transaction: Transaction.mock)
            .environment(SettingsStore())
        
        TransactionRowView(transaction: Transaction.mock)
            .environment(SettingsStore())
    }
}
