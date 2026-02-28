//
//  CardBackground.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct CardBackground: View {
    @Environment(\.colorScheme) private var colorScheme

    var body: some View {
        RoundedRectangle(cornerRadius: 16, style: .continuous)
            .fill(backgroundFill)
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(borderColor, lineWidth: 1)
            )
            .shadow(
                color: shadowColor,
                radius: shadowRadius,
                x: 0,
                y: shadowY
            )
    }

    private var backgroundFill: AnyShapeStyle {
        switch colorScheme {
        case .light:
            return AnyShapeStyle(Color(.systemBackground))
        case .dark:
            return AnyShapeStyle(.ultraThinMaterial)
        @unknown default:
            return AnyShapeStyle(Color(.systemBackground))
        }
    }

    private var borderColor: Color {
        colorScheme == .light
            ? Color.black.opacity(0.05)
            : Color.white.opacity(0.08)
    }

    private var shadowColor: Color {
        colorScheme == .light
            ? Color.black.opacity(0.06)
            : .clear
    }

    private var shadowRadius: CGFloat {
        colorScheme == .light ? 8 : 0
    }

    private var shadowY: CGFloat {
        colorScheme == .light ? 4 : 0
    }
}

#Preview {
    CardBackground()
}

