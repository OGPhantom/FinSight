//
//  AppAccentColor.swift
//  FinSight
//
//  Created by Никита Сторчай on 30.03.2026.
//

import SwiftUI

enum AppAccentColor: String, CaseIterable {
    case mintTeal
    case green
    case blue
    case purple
    case orange

    var color: Color {
        switch self {
        case .mintTeal:
            return Color(
            red: 0.200,
            green: 0.850,
            blue: 0.780
        )

        case .green: return .green
        case .blue: return .blue
        case .purple: return .purple
        case .orange: return .orange
        }
    }
}
