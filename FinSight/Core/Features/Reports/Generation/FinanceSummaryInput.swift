//
//  FinanceSummaryInput.swift
//  FinSight
//
//  Created by Никита Сторчай on 07.02.2026.
//

import Foundation

struct FinanceSummaryInput {
    let startDate: Date
    let endDate: Date
    let totalSpent: Double
    let totalsByCategory: [Category: Double]
    let flaggedCategories: [Category: Double]
    let topMerchants: [String: Double]

    init(startDate: Date, endDate: Date, totalSpent: Double, totalsByCategory: [Category : Double], flaggedCategories: [Category : Double], topMerchants: [String : Double]) {
        self.startDate = startDate
        self.endDate = endDate
        self.totalSpent = totalSpent
        self.totalsByCategory = totalsByCategory
        self.flaggedCategories = flaggedCategories
        self.topMerchants = topMerchants
    }

    init(from transactions: [Transaction]) {
        var categoryTotals: [Category: Double] = [:]
        var merchantsTotals: [String: Double] = [:]
        var spentAcummulator: Double = 0.0

        if let minDate = transactions.map({ $0.date }).min(), let maxDate = transactions.map({ $0.date }).max() {
            self.startDate = minDate
            self.endDate = maxDate
        } else {
            let now = Date()
            self.startDate = now
            self.endDate = now
        }

        for transaction in transactions {
            let amount = transaction.amount
            spentAcummulator += amount
            categoryTotals[transaction.category, default: 0] += amount

            let merchant = transaction.merchant
            merchantsTotals[merchant, default: 0] += amount
        }

        self.totalSpent = spentAcummulator
        self.totalsByCategory = categoryTotals
        self.topMerchants = merchantsTotals

        let categoriesValues = Array(categoryTotals.values)
        let avgValue = ((categoriesValues.reduce(0, +)) / Double(categoriesValues.count))

        self.flaggedCategories = categoryTotals.filter { $0.value > avgValue}
    }
}

extension FinanceSummaryInput {
    static var mockThisWeek: FinanceSummaryInput {
        // Determine current week bounds (Mon 00:00:00 to Sun 23:59:59) in the current calendar
        let calendar = Calendar.current
        let now = Date()

        // Find the weekday component and compute the start of week as Monday
        let weekday = calendar.component(.weekday, from: now)
        // In Apple's calendar: 1 = Sunday, 2 = Monday, ... 7 = Saturday
        let daysFromMonday = (weekday + 5) % 7 // 0 for Monday, 1 for Tuesday, ... 6 for Sunday
        guard let startOfToday = calendar.startOfDay(for: now) as Date?,
              let startOfWeek = calendar.date(byAdding: .day, value: -daysFromMonday, to: startOfToday),
              let endOfWeek = calendar.date(byAdding: DateComponents(day: 6, hour: 23, minute: 59, second: 59), to: startOfWeek) else {
            // Fallback: one-week window ending today
            let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: now)) ?? now
            return FinanceSummaryInput(
                startDate: start,
                endDate: now,
                totalSpent: 642,
                totalsByCategory: [
                    .groceries: 176,
                    .transport: 88,
                    .dining: 114,
                    .utilities: 120,
                    .entertainment: 64,
                    .shopping: 56,
                    .other: 24
                ],
                flaggedCategories: [
                    .utilities: 120,
                    .dining: 114
                ],
                topMerchants: [
                    "Whole Foods": 96,
                    "City Transit": 54,
                    "Apple Services": 29
                ]
            )
        }

        let totalsByCategory: [Category: Double] = [
            .groceries: 176,
            .transport: 88,
            .dining: 114,
            .utilities: 120,
            .entertainment: 64,
            .shopping: 56,
            .other: 24
        ]

        let totalSpent = totalsByCategory.values.reduce(0, +)

        let flagged: [Category: Double] = [
            .utilities: totalsByCategory[.utilities] ?? 0,
            .dining: totalsByCategory[.dining] ?? 0
        ]

        let topMerchants: [String: Double] = [
            "Whole Foods": 96,
            "City Transit": 54,
            "Apple Services": 29,
            "Netflix": 15,
            "Blue Line Diner": 52
        ]

        return FinanceSummaryInput(
            startDate: startOfWeek,
            endDate: endOfWeek,
            totalSpent: totalSpent,
            totalsByCategory: totalsByCategory,
            flaggedCategories: flagged,
            topMerchants: topMerchants
        )
    }
}

