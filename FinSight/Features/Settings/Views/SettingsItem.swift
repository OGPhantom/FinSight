//
//  SettingsItem.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

enum SettingsItem: CaseIterable, Identifiable {
    case currency
    case appearance
    case categories
    case resetData
    case analytics

    var id: Self { self }

    var title: String {
        switch self {
        case .currency: return "Currency"
        case .appearance: return "Appearance"
        case .categories: return "Categories"
        case .resetData: return "Reset Data"
        case .analytics: return "Analytics"
        }
    }

    var subtitle: String {
        switch self {
        case .categories: return "Manage categories"
        case .appearance: return "Theme & style"
        case .resetData: return "Clear all app data"
        case .currency: return "Select app currency"
        case .analytics: return "Statistics & charts"
        }
    }

    var icon: String {
        switch self {
        case .currency: return "dollarsign.circle"
        case .appearance: return "paintbrush"
        case .categories: return "square.grid.2x2"
        case .resetData: return "trash"
        case .analytics: return "chart.pie"
        }
    }

    var iconColor: Color {
        switch self {
        case .currency: return .blue
        case .appearance: return .purple
        case .categories: return .orange
        case .resetData: return .red
        case .analytics: return .teal
        }
    }
    
    var bgColor: Color {
            switch self {
            case .currency: return Color.blue.opacity(0.8)
            case .appearance: return Color.purple.opacity(0.8)
            case .categories: return Color.orange.opacity(0.8)
            case .resetData: return Color.red.opacity(0.8)
            case .analytics: return Color.teal.opacity(0.8)
            }
        }

    var isWide: Bool {
        switch self {
        case .analytics:
            return true
        default:
            return false
        }
    }
}

