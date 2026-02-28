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
            Text("Sort by")
                .foregroundStyle(.secondary)

            Spacer()

            Menu {
                ForEach(TransactionSort.allCases, id: \.self) { option in
                    Button {
                        sorting.toggle(option)
                    } label: {
                        HStack {
                            Text(option.rawValue)

                            Spacer()
                            
                            if sorting.sort == option {
                                Image(systemName: sorting.order == .ascending ? "arrow.up" : "arrow.down")
                            }
                        }
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
        .modifier(CardRowModifier())
    }
}
