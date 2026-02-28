//
//  CardRowModifier.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import SwiftUI

struct CardRowModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .background(CardBackground())
            .listRowInsets(
                EdgeInsets(
                    top: 6,
                    leading: 16,
                    bottom: 6,
                    trailing: 16
                )
            )
            .listRowSeparator(.hidden)
            .listRowBackground(Color.clear)
    }
}
