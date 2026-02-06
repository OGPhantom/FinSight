//
//  SortToolbarButton.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct SortToolbarButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "arrow.up.arrow.down")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(8)
                .background(
                    Circle()
                        .fill(Color.accentColor)
                        .shadow(
                            color: Color.accentColor.opacity(0.4),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                )
        }
    }
}
