//
//  Transaction.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import Foundation
import SwiftUI

struct Transaction: Identifiable {
    var id: UUID
    var amount: Double
    var date: Date
    var merchant: String
    var category: Category
    var isSubscription: Bool
    var notes: String?

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

    }
}
