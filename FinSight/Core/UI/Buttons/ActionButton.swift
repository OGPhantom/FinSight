//
//  ActionButton.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct ActionButton: View {
    let action: () -> Void
    let image: String

    var body: some View {
        Button(action: action) {
            Image(systemName: image)
                .font(.system(size: 28, weight: .semibold))
                .foregroundStyle(.white)
                .padding(16)
                .background(
                    Circle()
                        .fill(Color(red: 0.20, green: 0.85, blue: 0.78))
                        .shadow(
                            color: Color(red: 0.20, green: 0.85, blue: 0.78).opacity(0.4),
                            radius: 8,
                            x: 0,
                            y: 4
                        )
                )
        }
        .padding(.trailing, 20)
        .padding(.bottom, 10)
    }
}
