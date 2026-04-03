//
//  TransactionCategory.swift
//  FinSight
//
//  Created by OpenAI on 03.04.2026.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class TransactionCategory: Identifiable {
    @Attribute(.unique) var id: UUID
    var name: String
    var colorHex: String
    var iconName: String?
    var legacyKey: String?
    var isSystem: Bool
    var sortIndex: Int
    var createdAt: Date

    var transactions: [Transaction]

    init(
        id: UUID = Foundation.UUID(),
        name: String,
        colorHex: String,
        iconName: String? = nil,
        legacyKey: String? = nil,
        isSystem: Bool = false,
        sortIndex: Int = 0,
        createdAt: Date = Foundation.Date()
    ) {
        self.id = id
        self.name = name
        self.colorHex = colorHex
        self.iconName = iconName
        self.legacyKey = legacyKey
        self.isSystem = isSystem
        self.sortIndex = sortIndex
        self.createdAt = createdAt
        self.transactions = []
    }

    var color: Color {
        Color(hex: colorHex) ?? .gray
    }

    var snapshot: CategorySnapshot {
        CategorySnapshot(
            id: id.uuidString,
            name: name,
            colorHex: colorHex,
            iconName: iconName
        )
    }
}

extension TransactionCategory {
    static let suggestedColors: [String] = [
        "#4E8F4B",
        "#C46A35",
        "#4B6FA8",
        "#8756B1",
        "#B55A8C",
        "#C4A23A",
        "#C45B5B",
        "#3C8E93",
        "#5962C8",
        "#7B7F87"
    ]

    static let suggestedIcons: [String] = [
        "cart.fill",
        "fork.knife",
        "car.fill",
        "bag.fill",
        "film.fill",
        "bolt.fill",
        "heart.fill",
        "airplane",
        "repeat.circle.fill",
        "tag.fill"
    ]

    static func makeDefault(from legacy: Category, index: Int) -> TransactionCategory {
        TransactionCategory(
            name: legacy.displayName,
            colorHex: legacy.defaultColorHex,
            iconName: legacy.defaultIconName,
            legacyKey: legacy.rawValue,
            isSystem: true,
            sortIndex: index
        )
    }
}
