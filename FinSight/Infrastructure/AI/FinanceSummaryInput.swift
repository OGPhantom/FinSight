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
    let totalsByCategory: [CategorySpendSummary]
    let flaggedCategories: [CategorySpendSummary]
    let topMerchants: [String: Double]

    init(
        startDate: Date,
        endDate: Date,
        totalSpent: Double,
        totalsByCategory: [CategorySpendSummary],
        flaggedCategories: [CategorySpendSummary],
        topMerchants: [String: Double]
    ) {
        self.startDate = startDate
        self.endDate = endDate
        self.totalSpent = totalSpent
        self.totalsByCategory = totalsByCategory
        self.flaggedCategories = flaggedCategories
        self.topMerchants = topMerchants
    }

    init(from transactions: [Transaction]) {
        var categoryTotals: [String: (snapshot: CategorySnapshot, amount: Double)] = [:]
        var merchantsTotals: [String: Double] = [:]
        var spentAccumulator: Double = 0

        if let minDate = transactions.map(\.date).min(),
           let maxDate = transactions.map(\.date).max() {
            self.startDate = minDate
            self.endDate = maxDate
        } else {
            let now = Date()
            self.startDate = now
            self.endDate = now
        }

        for transaction in transactions {
            let amount = transaction.amount
            spentAccumulator += amount

            let snapshot = transaction.categorySnapshot
            categoryTotals[snapshot.id, default: (snapshot, 0)].amount += amount
            merchantsTotals[transaction.merchant, default: 0] += amount
        }

        let totals = categoryTotals.values
            .map { CategorySpendSummary(snapshot: $0.snapshot, amount: $0.amount) }
            .sorted { $0.amount > $1.amount }

        let averageAmount = totals.isEmpty
            ? 0
            : totals.reduce(0) { $0 + $1.amount } / Double(totals.count)

        self.totalSpent = spentAccumulator
        self.totalsByCategory = totals
        self.topMerchants = merchantsTotals
        self.flaggedCategories = totals.filter { $0.amount > averageAmount }
    }
}

extension FinanceSummaryInput {
    static var mockThisWeek: FinanceSummaryInput {
        let calendar = Calendar.current
        let now = Date()

        let weekday = calendar.component(.weekday, from: now)
        let daysFromMonday = (weekday + 5) % 7
        let start = calendar.date(byAdding: .day, value: -daysFromMonday, to: calendar.startOfDay(for: now)) ?? now
        let end = calendar.date(byAdding: DateComponents(day: 6, hour: 23, minute: 59, second: 59), to: start) ?? now

        let groceries = CategorySnapshot(id: "groceries", name: "Groceries", colorHex: Category.groceries.defaultColorHex, iconName: Category.groceries.defaultIconName)
        let transport = CategorySnapshot(id: "transport", name: "Transport", colorHex: Category.transport.defaultColorHex, iconName: Category.transport.defaultIconName)
        let dining = CategorySnapshot(id: "dining", name: "Dining", colorHex: Category.dining.defaultColorHex, iconName: Category.dining.defaultIconName)
        let utilities = CategorySnapshot(id: "utilities", name: "Utilities", colorHex: Category.utilities.defaultColorHex, iconName: Category.utilities.defaultIconName)
        let entertainment = CategorySnapshot(id: "entertainment", name: "Entertainment", colorHex: Category.entertainment.defaultColorHex, iconName: Category.entertainment.defaultIconName)
        let shopping = CategorySnapshot(id: "shopping", name: "Shopping", colorHex: Category.shopping.defaultColorHex, iconName: Category.shopping.defaultIconName)
        let other = CategorySnapshot(id: "other", name: "Other", colorHex: Category.other.defaultColorHex, iconName: Category.other.defaultIconName)

        let totalsByCategory: [CategorySpendSummary] = [
            .init(snapshot: groceries, amount: 176),
            .init(snapshot: transport, amount: 88),
            .init(snapshot: dining, amount: 114),
            .init(snapshot: utilities, amount: 120),
            .init(snapshot: entertainment, amount: 64),
            .init(snapshot: shopping, amount: 56),
            .init(snapshot: other, amount: 24)
        ]

        let flaggedCategories: [CategorySpendSummary] = [
            .init(snapshot: utilities, amount: 120),
            .init(snapshot: dining, amount: 114)
        ]

        return FinanceSummaryInput(
            startDate: start,
            endDate: end,
            totalSpent: totalsByCategory.reduce(0) { $0 + $1.amount },
            totalsByCategory: totalsByCategory,
            flaggedCategories: flaggedCategories,
            topMerchants: [
                "Whole Foods": 96,
                "City Transit": 54,
                "Apple Services": 29,
                "Netflix": 15,
                "Blue Line Diner": 52
            ]
        )
    }
}
