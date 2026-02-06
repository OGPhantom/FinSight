//
//  AddActionButton.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct AddActionButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .semibold))
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
