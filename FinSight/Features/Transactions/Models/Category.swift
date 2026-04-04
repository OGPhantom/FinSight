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
    case coffee
    case transport
    case shopping
    case entertainment
    case utilities
    case health
    case fitness
    case beauty
    case home
    case education
    case work
    case insurance
    case gifts
    case pets
    case family
    case taxes
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
        case .coffee:
            return "Coffee"
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
        case .fitness:
            return "Fitness"
        case .beauty:
            return "Beauty"
        case .home:
            return "Home"
        case .education:
            return "Education"
        case .work:
            return "Work"
        case .insurance:
            return "Insurance"
        case .gifts:
            return "Gifts"
        case .pets:
            return "Pets"
        case .family:
            return "Family"
        case .taxes:
            return "Taxes"
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
        case .coffee:
            return ("cup.and.saucer.fill", .brown)
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
        case .fitness:
            return ("figure.run", .mint)
        case .beauty:
            return ("sparkles", .pink)
        case .home:
            return ("house.fill", .indigo)
        case .education:
            return ("book.fill", .cyan)
        case .work:
            return ("briefcase.fill", .blue)
        case .insurance:
            return ("shield.fill", .teal)
        case .gifts:
            return ("gift.fill", .red)
        case .pets:
            return ("pawprint.fill", .orange)
        case .family:
            return ("figure.2.and.child.holdinghands", .purple)
        case .taxes:
            return ("receipt.fill", .gray)
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
        case .coffee: return "#8A5A44"
        case .transport: return "#4B6FA8"
        case .shopping: return "#8756B1"
        case .entertainment: return "#B55A8C"
        case .utilities: return "#C4A23A"
        case .health: return "#C45B5B"
        case .fitness: return "#2F9D7E"
        case .beauty: return "#C06C9B"
        case .home: return "#5B68C5"
        case .education: return "#3C8FB1"
        case .work: return "#4C7BA9"
        case .insurance: return "#4F8C88"
        case .gifts: return "#C05A6A"
        case .pets: return "#C78742"
        case .family: return "#8B67B8"
        case .taxes: return "#6B7280"
        case .travel: return "#3C8E93"
        case .subscriptions: return "#5962C8"
        case .other: return "#7B7F87"
        }
    }

    var defaultIconName: String {
        iconInfo.symbol
    }
}
