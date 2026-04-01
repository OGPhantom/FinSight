//
//  AppAccentColor.swift
//  FinSight
//
//  Created by Никита Сторчай on 30.03.2026.
//

import SwiftUI

enum AppAccentColor: String, CaseIterable {
    case indigo
    case ocean
    case forest
    case plum
    case rosewood
    case amber
    case slate
    case sky

    var color: Color {
        switch self {
        case .indigo:
            return Color(red: 0.36, green: 0.42, blue: 0.95)

        case .ocean:
            return Color(red: 0.20, green: 0.55, blue: 0.72)

        case .forest:
            return Color(red: 0.22, green: 0.60, blue: 0.42)

        case .plum:
            return Color(red: 0.52, green: 0.38, blue: 0.72)

        case .rosewood:
            return Color(red: 0.78, green: 0.36, blue: 0.44)

        case .amber:
            return Color(red: 0.86, green: 0.64, blue: 0.24)

        case .slate:
            return Color(red: 0.38, green: 0.46, blue: 0.58)

        case .sky:
            return Color(red: 0.38, green: 0.63, blue: 0.90)
        }
    }

    var title: String {
        switch self {
        case .indigo: return "Indigo"
        case .ocean: return "Ocean"
        case .forest: return "Forest"
        case .plum: return "Plum"
        case .rosewood: return "Rosewood"
        case .amber: return "Amber"
        case .slate: return "Slate"
        case .sky: return "Sky"
        }
    }
}
