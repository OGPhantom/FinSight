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
    
    var overview: String
    var keyInsights: [String]
    var recommendations: [String]

    var createdAt: Date

    init(
        startDate: Date,
        endDate: Date,
        overview: String,
        keyInsights: [String],
        recommendations: [String]
    ) {
        self.startDate = startDate
        self.endDate = endDate
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

        return WeeklyReport(
            startDate: startDate,
            endDate: endDate,
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

        func makeReport(weeksAgo: Int, overview: String, insights: [String], recommendations: [String]) -> WeeklyReport {
            let endDate = calendar.date(byAdding: .day, value: -(weeksAgo * 7), to: now) ?? now
            let startDate = calendar.date(byAdding: .day, value: -6, to: endDate) ?? endDate

            return WeeklyReport(
                startDate: startDate,
                endDate: endDate,
                overview: overview,
                keyInsights: insights,
                recommendations: recommendations
            )
        }

        return [
            .mock,

            makeReport(
                weeksAgo: 1,
                overview: "Spending increased slightly compared to the previous week, mainly due to travel and entertainment expenses.",
                insights: [
                    "Travel spending was the highest category this week.",
                    "Entertainment expenses increased due to weekend activities.",
                    "Groceries and utilities remained stable."
                ],
                recommendations: [
                    "Look for travel discounts or loyalty programs to reduce future costs.",
                    "Set a soft cap for entertainment spending on weekends."
                ]
            ),

            makeReport(
                weeksAgo: 2,
                overview: "Overall spending was lower this week, with fewer discretionary purchases and consistent essential expenses.",
                insights: [
                    "Dining expenses decreased noticeably.",
                    "Subscriptions continued to be the most predictable recurring cost.",
                    "No major spending spikes were detected."
                ],
                recommendations: [
                    "Maintain current spending habits to keep expenses stable.",
                    "Periodically review subscriptions to ensure they still provide value."
                ]
            )
        ]
    }
}

