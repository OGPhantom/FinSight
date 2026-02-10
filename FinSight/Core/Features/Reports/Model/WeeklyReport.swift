//
//  WeeklyReport.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import Foundation
import SwiftData

@Model
final class WeeklyReport {
    var startDate: Date
    var endDate: Date

    var totalSpent: Double
    var totalsByCategory: [Category: Double]
    var flaggedCategories: [Category: Double]
    var topMerchants: [String: Double]

    var overview: String
    var keyInsights: [String]
    var recommendations: [String]

    var createdAt: Date

    init(
        startDate: Date,
        endDate: Date,
        totalSpent: Double,
        totalsByCategory: [Category: Double],
        flaggedCategories: [Category: Double],
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
}

extension WeeklyReport {

    static var mock: WeeklyReport {
        let calendar = Calendar.current
        let now = Date()

        let endDate = now
        let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) ?? now

        let totalsByCategory: [Category: Double] = [
            .groceries: 128.40,
            .dining: 76.30,
            .subscriptions: 42.99,
            .transport: 38.77,
            .entertainment: 30.00
        ]

        let flaggedCategories: [Category: Double] = [
            .groceries: 128.40,
            .dining: 76.30
        ]

        let topMerchants: [String: Double] = [
            "Trader Joe's": 82.10,
            "Amazon": 54.99,
            "Starbucks": 29.50,
            "Netflix": 15.99
        ]

        let totalSpent = totalsByCategory.values.reduce(0, +)

        return WeeklyReport(
            startDate: startDate,
            endDate: endDate,
            totalSpent: totalSpent,
            totalsByCategory: totalsByCategory,
            flaggedCategories: flaggedCategories,
            topMerchants: topMerchants,
            overview: "Your spending for the week was steady, with dining and groceries as the main contributors. Discretionary spending remained controlled, while subscriptions added predictable recurring costs.",
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

    static var mocks: [WeeklyReport] {
        let calendar = Calendar.current
        let now = Date()

        func makeReport(
            weeksAgo: Int,
            totalsByCategory: [Category: Double],
            flaggedCategories: [Category: Double],
            topMerchants: [String: Double],
            overview: String,
            insights: [String],
            recommendations: [String]
        ) -> WeeklyReport {

            let endDate = calendar.date(byAdding: .day, value: -(weeksAgo * 7), to: now) ?? now
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) ?? endDate
            let totalSpent = totalsByCategory.values.reduce(0, +)

            return WeeklyReport(
                startDate: startDate,
                endDate: endDate,
                totalSpent: totalSpent,
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
                    .travel: 120.00,
                    .entertainment: 68.40,
                    .groceries: 94.20
                ],
                flaggedCategories: [
                    .travel: 120.00
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
                    .groceries: 72.80,
                    .subscriptions: 39.98,
                    .utilities: 61.20
                ],
                flaggedCategories: [:],
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

