//
//  CustomReport.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import Foundation
import SwiftData

@Model
final class CustomReport {
    var startDate: Date
    var endDate: Date

    var totalSpent: Double
    var totalsByCategory: [CategorySpendSummary]
    var flaggedCategories: [CategorySpendSummary]
    var topMerchants: [String: Double]

    var overview: String
    var keyInsights: [String]
    var recommendations: [String]

    var createdAt: Date

    init(
        startDate: Date,
        endDate: Date,
        totalSpent: Double,
        totalsByCategory: [CategorySpendSummary],
        flaggedCategories: [CategorySpendSummary],
        topMerchants: [String: Double],
        overview: String,
        keyInsights: [String],
        recommendations: [String]
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.totalSpent = totalSpent
        self.totalsByCategory = totalsByCategory
        self.flaggedCategories = flaggedCategories
        self.topMerchants = topMerchants
        self.overview = overview
        self.keyInsights = keyInsights
        self.recommendations = recommendations
        self.createdAt = .now
    }

    var dateRangeText: String {
        "\(startDate.formatted(date: .abbreviated, time: .omitted)) – \(endDate.formatted(date: .abbreviated, time: .omitted))"
    }

    var topCategory: CategorySpendSummary? {
        sortedCategories.first
    }

    var topMerchant: (name: String, amount: Double)? {
        topMerchants.max { lhs, rhs in
            lhs.value < rhs.value
        }
        .map { (name: $0.key, amount: $0.value) }
    }

    var sortedCategories: [CategorySpendSummary] {
        totalsByCategory.sorted { $0.amount > $1.amount }
    }

    var sortedFlaggedCategories: [CategorySpendSummary] {
        flaggedCategories.sorted { $0.amount > $1.amount }
    }

    var sortedTopMerchants: [(name: String, amount: Double)] {
        topMerchants
            .sorted { lhs, rhs in
                lhs.value > rhs.value
            }
            .map { (name: $0.key, amount: $0.value) }
    }
}

extension CustomReport {
    private static func snapshot(for legacy: Category) -> CategorySnapshot {
        CategorySnapshot(
            id: legacy.rawValue,
            name: legacy.displayName,
            colorHex: legacy.defaultColorHex,
            iconName: legacy.defaultIconName
        )
    }

    static var mock: CustomReport {
        let calendar = Calendar.current
        let now = Date()

        let endDate = now
        let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) ?? now

        let totalsByCategory: [CategorySpendSummary] = [
            .init(snapshot: snapshot(for: .groceries), amount: 128.40),
            .init(snapshot: snapshot(for: .dining), amount: 76.30),
            .init(snapshot: snapshot(for: .subscriptions), amount: 42.99),
            .init(snapshot: snapshot(for: .transport), amount: 38.77),
            .init(snapshot: snapshot(for: .entertainment), amount: 30.00)
        ]

        let flaggedCategories: [CategorySpendSummary] = [
            .init(snapshot: snapshot(for: .groceries), amount: 128.40),
            .init(snapshot: snapshot(for: .dining), amount: 76.30)
        ]

        let topMerchants: [String: Double] = [
            "Trader Joe's": 82.10,
            "Amazon": 54.99,
            "Starbucks": 29.50,
            "Netflix": 15.99
        ]

        return CustomReport(
            startDate: startDate,
            endDate: endDate,
            totalSpent: totalsByCategory.reduce(0) { $0 + $1.amount },
            totalsByCategory: totalsByCategory,
            flaggedCategories: flaggedCategories,
            topMerchants: topMerchants,
            overview: "Your spending for the week was steady, with dining and groceries as the main contributors.",
            keyInsights: [
                "Groceries accounted for the highest spend this week, driven by a large stock-up purchase.",
                "Dining expenses were frequent but moderate, suggesting regular eating out.",
                "Subscriptions continued to add consistent recurring costs across multiple services.",
                "Travel and transport spending spiked slightly due to weekend activity."
            ],
            recommendations: [
                "Consider setting a weekly grocery budget to avoid large one-time spikes.",
                "Review active subscriptions and pause or cancel unused services.",
                "Plan meals ahead of time to reduce dining expenses during the week."
            ]
        )
    }

    static var mocks: [CustomReport] {
        let calendar = Calendar.current
        let now = Date()

        func makeReport(
            weeksAgo: Int,
            totalsByCategory: [CategorySpendSummary],
            flaggedCategories: [CategorySpendSummary],
            topMerchants: [String: Double],
            overview: String,
            insights: [String],
            recommendations: [String]
        ) -> CustomReport {
            let endDate = calendar.date(byAdding: .day, value: -(weeksAgo * 7), to: now) ?? now
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) ?? endDate

            return CustomReport(
                startDate: startDate,
                endDate: endDate,
                totalSpent: totalsByCategory.reduce(0) { $0 + $1.amount },
                totalsByCategory: totalsByCategory,
                flaggedCategories: flaggedCategories,
                topMerchants: topMerchants,
                overview: overview,
                keyInsights: insights,
                recommendations: recommendations
            )
        }

        return [
            .mock,
            makeReport(
                weeksAgo: 1,
                totalsByCategory: [
                    .init(snapshot: snapshot(for: .travel), amount: 120.00),
                    .init(snapshot: snapshot(for: .entertainment), amount: 68.40),
                    .init(snapshot: snapshot(for: .groceries), amount: 94.20)
                ],
                flaggedCategories: [
                    .init(snapshot: snapshot(for: .travel), amount: 120.00)
                ],
                topMerchants: [
                    "Southwest": 120.00,
                    "AMC": 68.40
                ],
                overview: "Spending increased compared to the previous week, mainly due to travel and entertainment expenses.",
                insights: [
                    "Travel was the highest spending category this week.",
                    "Entertainment costs increased due to weekend activities.",
                    "Essential spending remained stable."
                ],
                recommendations: [
                    "Look for travel discounts or loyalty programs.",
                    "Set a soft cap for weekend entertainment spending."
                ]
            ),
            makeReport(
                weeksAgo: 2,
                totalsByCategory: [
                    .init(snapshot: snapshot(for: .groceries), amount: 72.80),
                    .init(snapshot: snapshot(for: .subscriptions), amount: 39.98),
                    .init(snapshot: snapshot(for: .utilities), amount: 61.20)
                ],
                flaggedCategories: [],
                topMerchants: [
                    "Apple Music": 9.99,
                    "Netflix": 15.99,
                    "Electric Co.": 61.20
                ],
                overview: "Overall spending was lower this week, with fewer discretionary purchases and consistent essential expenses.",
                insights: [
                    "Dining expenses decreased noticeably.",
                    "Subscriptions remained predictable.",
                    "No major spending spikes were detected."
                ],
                recommendations: [
                    "Maintain current spending habits.",
                    "Continue monitoring subscriptions periodically."
                ]
            )
        ]
    }
}
