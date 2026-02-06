//
//  TransactionRowBackground.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionRowBackground: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(Color(.systemBackground))
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(Color.black.opacity(0.05), lineWidth: 1)
            )
            .shadow(
                color: Color.black.opacity(0.04),
                radius: 8,
                x: 0,
                y: 4
            )
    }
}


#Preview {
    TransactionRowBackground()
}
