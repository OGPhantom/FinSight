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
        case .categories: return "Edit categories"
        case .appearance: return "Theme & style"
        case .resetData: return "Delete app data"
        case .currency: return "App currency"
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
        case .currency: return Color(hex: "#4B6FA8") ?? .blue
        case .appearance: return Color(hex: "#8756B1") ?? . purple
        case .categories: return Color(hex: "#C78742") ?? .orange
        case .resetData: return Color(hex: "#C45B5B") ?? .red
        case .analytics: return Color(hex: "#4F8C88") ?? .teal
        }
    }

    var bgColor: Color {
        switch self {
        case .currency: return Color(hex: "#4B6FA8") ?? Color.blue.opacity(0.8)
        case .appearance: return Color(hex: "#8756B1") ?? Color.purple.opacity(0.8)
        case .categories: return Color(hex: "#C78742") ?? Color.orange.opacity(0.8)
        case .resetData: return Color(hex: "#C45B5B") ?? Color.red.opacity(0.8)
        case .analytics: return Color(hex: "#4F8C88") ??  Color.teal.opacity(0.8)
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

