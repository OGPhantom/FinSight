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
    var isSubscription: Bool
    var notes: String?

    init(id: UUID, amount: Double, date: Date, merchant: String, category: Category, isSubscription: Bool, notes: String? = nil) {
        self.id = id
        self.amount = amount
        self.date = date
        self.merchant = merchant
        self.category = category
        self.isSubscription = isSubscription
        self.notes = notes
    }

    static func makeTransaction(
        id: UUID = UUID(),
        amount: Double,
        daysAgo: Int = 0,
        merchant: String,
        category: Category,
        isSubscription: Bool = false,
        notes: String? = nil
    ) -> Transaction {
        Transaction(
            id: id,
            amount: amount,
            date: Calendar.current.date(byAdding: .day, value: -daysAgo, to: Date()) ?? Date(),
            merchant: merchant,
            category: category,
            isSubscription: isSubscription,
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
        [
            .makeTransaction(amount: 23.45, daysAgo: 1, merchant: "Trader Joe's", category: .groceries, notes: "Snacks and veggies"),
            .makeTransaction(amount: 12.99, daysAgo: 0, merchant: "Starbucks", category: .dining, notes: "Latte and muffin"),
            .makeTransaction(amount: 42.10, daysAgo: 3, merchant: "Uber", category: .transport),
            .makeTransaction(amount: 89.99, daysAgo: 5, merchant: "Amazon", category: .shopping, notes: "Household items"),
            .makeTransaction(amount: 15.00, daysAgo: 2, merchant: "Netflix", category: .subscriptions, isSubscription: true),
            .makeTransaction(amount: 65.30, daysAgo: 7, merchant: "PG&E", category: .utilities, notes: "Electric bill"),
            .makeTransaction(amount: 29.99, daysAgo: 6, merchant: "Apple Music", category: .subscriptions, isSubscription: true),
            .makeTransaction(amount: 58.75, daysAgo: 4, merchant: "AMC", category: .entertainment, notes: "Movie night"),
            .makeTransaction(amount: 120.00, daysAgo: 10, merchant: "Southwest", category: .travel, notes: "Weekend trip"),
            .makeTransaction(amount: 34.50, daysAgo: 8, merchant: "CVS", category: .health, notes: "Medicine"),
            .makeTransaction(amount: 9.99, daysAgo: 9, merchant: "iCloud", category: .subscriptions, isSubscription: true),
            .makeTransaction(amount: 7.25, daysAgo: 1, merchant: "Parking Meter", category: .transport),
            .makeTransaction(amount: 19.80, daysAgo: 2, merchant: "Chipotle", category: .dining),
            .makeTransaction(amount: 210.00, daysAgo: 12, merchant: "Costco", category: .groceries, notes: "Monthly stock-up"),
            .makeTransaction(amount: 14.29, daysAgo: 11, merchant: "App Store", category: .entertainment, notes: "Game purchase"),
            .makeTransaction(amount: 49.00, daysAgo: 13, merchant: "Hulu", category: .subscriptions, isSubscription: true),
            .makeTransaction(amount: 5.49, daysAgo: 0, merchant: "7-Eleven", category: .other, notes: "Bottled water")
        ]
    }
}
