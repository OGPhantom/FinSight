//
//  TransactionsSortHeader.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct TransactionsSortHeader: View {
    @Binding var sorting: TransactionSorting

    var body: some View {
        HStack {
            Text("Sort")
                .foregroundStyle(.secondary)

            Spacer()

            Menu {
                ForEach(TransactionSort.allCases, id: \.self) { option in
                    Button {
                        sorting.toggle(option)
                    } label: {
                        Label(option.rawValue, systemImage: sorting.icon(for: option))
                    }
                }
            } label: {
                HStack(spacing: 6) {
                    Text(sorting.sort.rawValue)
                    Image(systemName: sorting.order == .ascending ? "arrow.up" : "arrow.down")
                }
                .font(.subheadline.weight(.semibold))
            }
        }
        .padding(.horizontal)
        .padding(.vertical, 8)
    }
}
