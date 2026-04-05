//
//  TransactionCategory.swift
//  FinSight
//
//  Created by Никита Сторчай on 03.04.2026.
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
        "#7B7F87",
        "#8A5A44",
        "#2F9D7E",
        "#C06C9B",
        "#5B68C5",
        "#3C8FB1",
        "#4F8C88",
        "#C05A6A",
        "#C78742",
        "#8B67B8",
        "#6F7E4E",
        "#A55D4F",
        "#5676D1",
        "#4F9FA8",
        "#A06A2E",
        "#A14D78",
        "#64748B",
        "#7C5AC7",
        "#2D8C6A",
        "#B76952",
        "#47659B",
        "#9B8453",
        "#A95B5B",
        "#56606F",
        "#4A5E47",
        "#B66D8C"
    ]

    static let suggestedIcons: [String] = [
        "cart.fill",
        "fork.knife",
        "cup.and.saucer.fill",
        "car.fill",
        "tram.fill",
        "fuelpump.fill",
        "bag.fill",
        "basket.fill",
        "film.fill",
        "gamecontroller.fill",
        "ticket.fill",
        "bolt.fill",
        "heart.fill",
        "cross.case.fill",
        "figure.run",
        "dumbbell.fill",
        "sparkles",
        "scissors",
        "house.fill",
        "bed.double.fill",
        "book.fill",
        "graduationcap.fill",
        "briefcase.fill",
        "laptopcomputer",
        "shield.fill",
        "gift.fill",
        "pawprint.fill",
        "figure.2.and.child.holdinghands",
        "person.2.fill",
        "receipt.fill",
        "banknote.fill",
        "airplane",
        "suitcase.fill",
        "repeat.circle.fill",
        "tv.fill",
        "music.note",
        "phone.fill",
        "wifi",
        "tag.fill",
        "ellipsis.circle.fill",
        "leaf.fill",
        "drop.fill",
        "building.2.fill",
        "hammer.fill",
        "paintbrush.fill",
        "fork.knife.circle.fill",
        "stethoscope",
        "bicycle.circle.fill",
        "camera.fill"
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
