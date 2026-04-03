//
//  Category.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import Foundation
import SwiftUI

// Legacy enum preserved for default seeding and migration from the original schema.
enum Category: String, Codable, CaseIterable, Identifiable {
    case groceries
    case dining
    case transport
    case shopping
    case entertainment
    case utilities
    case health
    case travel
    case subscriptions
    case other

    var id: String { rawValue }

    var displayName: String {
        switch self {
        case .groceries:
            return "Groceries"
        case .dining:
            return "Dining"
        case .transport:
            return "Transport"
        case .shopping:
            return "Shopping"
        case .entertainment:
            return "Entertainment"
        case .utilities:
            return "Utilities"
        case .health:
            return "Health"
        case .travel:
            return "Travel"
        case .subscriptions:
            return "Subscriptions"
        case .other:
            return "Other"
        }
    }

    var iconInfo: (symbol: String, color: Color) {
        switch self {
        case .groceries:
            return ("cart.fill", .green)
        case .dining:
            return ("fork.knife.circle.fill", .orange)
        case .transport:
            return ("car.fill", .blue)
        case .shopping:
            return ("bag.fill", .purple)
        case .entertainment:
            return ("film.fill", .pink)
        case .utilities:
            return ("bolt.fill", .yellow)
        case .health:
            return ("heart.fill", .red)
        case .travel:
            return ("airplane", .teal)
        case .subscriptions:
            return ("repeat.circle.fill", .indigo)
        case .other:
            return ("ellipsis.circle.fill", .gray)
        }
    }

    var defaultColorHex: String {
        switch self {
        case .groceries: return "#4E8F4B"
        case .dining: return "#C46A35"
        case .transport: return "#4B6FA8"
        case .shopping: return "#8756B1"
        case .entertainment: return "#B55A8C"
        case .utilities: return "#C4A23A"
        case .health: return "#C45B5B"
        case .travel: return "#3C8E93"
        case .subscriptions: return "#5962C8"
        case .other: return "#7B7F87"
        }
    }

    var defaultIconName: String {
        iconInfo.symbol
    }
}
