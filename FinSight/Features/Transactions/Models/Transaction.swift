//
//  Transaction.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import Foundation
import SwiftUI
import SwiftData

@Model
final class Transaction: Identifiable {
    var id: UUID
    var amount: Double
    var date: Date
    var merchant: String
    var category: Category
    var notes: String?

    init(id: UUID, amount: Double, date: Date, merchant: String, category: Category, notes: String? = nil) {
        self.id = id
        self.amount = amount
        self.date = date
        self.merchant = merchant
        self.category = category
        self.notes = notes
    }

    static func makeTransaction(
        id: UUID = UUID(),
        amount: Double,
        daysAgo: Int = 0,
        merchant: String,
        category: Category,
        notes: String? = nil
    ) -> Transaction {
        Transaction(
            id: id,
            amount: amount,
            date: Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date(),
            merchant: merchant,
            category: category,
            notes: notes
        )
    }

    static var mock: Transaction {
        .makeTransaction(
            amount: 23.45,
            daysAgo: 1,
            merchant: "Trader Joe's",
            category: .groceries,
            notes: "Snacks and veggies"
        )
    }

    static var mocks: [Transaction] {
        var result: [Transaction] = []

        // MARK: - Last 7 days (dense activity)
        result += [
            .makeTransaction(amount: 12.99, daysAgo: 0, merchant: "Starbucks", category: .dining),
            .makeTransaction(amount: 5.49, daysAgo: 0, merchant: "7-Eleven", category: .other),
            .makeTransaction(amount: 23.45, daysAgo: 1, merchant: "Trader Joe's", category: .groceries),
            .makeTransaction(amount: 7.25, daysAgo: 1, merchant: "Parking Meter", category: .transport),
            .makeTransaction(amount: 19.80, daysAgo: 2, merchant: "Chipotle", category: .dining),
            .makeTransaction(amount: 42.10, daysAgo: 3, merchant: "Uber", category: .transport),
            .makeTransaction(amount: 58.75, daysAgo: 4, merchant: "AMC", category: .entertainment),
            .makeTransaction(amount: 89.99, daysAgo: 5, merchant: "Amazon", category: .shopping),
            .makeTransaction(amount: 29.99, daysAgo: 6, merchant: "Apple Music", category: .subscriptions)
        ]

        // MARK: - Weekly recurring patterns (last month)
        for day in stride(from: 7, to: 30, by: 3) {
            result.append(.makeTransaction(amount: Double.random(in: 8...25), daysAgo: day, merchant: "Lunch Spot", category: .dining))
        }

        for day in stride(from: 10, to: 30, by: 7) {
            result.append(.makeTransaction(amount: Double.random(in: 40...120), daysAgo: day, merchant: "Grocery Store", category: .groceries))
        }

        // MARK: - Monthly subscriptions
        let subscriptions = ["Netflix", "Spotify", "iCloud", "Hulu"]
        for (index, name) in subscriptions.enumerated() {
            result.append(.makeTransaction(amount: Double(10 + index * 5), daysAgo: 30 + index * 3, merchant: name, category: .subscriptions))
            result.append(.makeTransaction(amount: Double(10 + index * 5), daysAgo: 60 + index * 3, merchant: name, category: .subscriptions))
            result.append(.makeTransaction(amount: Double(10 + index * 5), daysAgo: 90 + index * 3, merchant: name, category: .subscriptions))
        }

        // MARK: - Utilities (monthly)
        for month in 1...4 {
            result.append(.makeTransaction(amount: Double.random(in: 50...120), daysAgo: month * 30, merchant: "Utility Bill", category: .utilities))
        }

        // MARK: - Medium purchases (quarter scale)
        result += [
            .makeTransaction(amount: 210.00, daysAgo: 35, merchant: "Costco", category: .groceries),
            .makeTransaction(amount: 320.00, daysAgo: 70, merchant: "IKEA", category: .shopping),
            .makeTransaction(amount: 180.00, daysAgo: 95, merchant: "Zara", category: .shopping)
        ]

        // MARK: - Travel / rare (year scale)
        result += [
            .makeTransaction(amount: 450.00, daysAgo: 120, merchant: "Airbnb", category: .travel),
            .makeTransaction(amount: 800.00, daysAgo: 200, merchant: "Emirates", category: .travel),
            .makeTransaction(amount: 1200.00, daysAgo: 300, merchant: "Apple Store", category: .shopping)
        ]

        return result
    }
}
