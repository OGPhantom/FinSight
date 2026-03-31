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
    case indigo
    case rose
    case amber

    var color: Color {
        switch self {
        case .mintTeal:
            return Color(red: 0.200, green: 0.850, blue: 0.780)

        case .green:
            return .green

        case .blue:
            return .blue

        case .purple:
            return .purple

        case .orange:
            return .orange

        case .indigo:
            return Color(red: 0.36, green: 0.42, blue: 0.95)

        case .rose:
            return Color(red: 0.95, green: 0.35, blue: 0.45)

        case .amber:
            return Color(red: 1.0, green: 0.75, blue: 0.2)
        }
    }

    var title: String {
        switch self {
        case .mintTeal: return "Mint"
        case .green: return "Green"
        case .blue: return "Blue"
        case .purple: return "Purple"
        case .orange: return "Orange"
        case .indigo: return "Indigo"
        case .rose: return "Rose"
        case .amber: return "Amber"
        }
    }
}
