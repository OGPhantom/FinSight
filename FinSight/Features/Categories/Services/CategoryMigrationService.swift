//
//  CategoryMigrationService.swift
//  FinSight
//
//  Created by Никита Сторчай on 03.04.2026.
//

import Foundation
import SwiftData

@MainActor
enum CategoryMigrationService {
    private static let didSeedCategoriesKey = "did_seed_transaction_categories_v1"

    static func prepare(using modelContext: ModelContext) throws {
        try seedDefaultCategoriesIfNeeded(using: modelContext)
        try migrateTransactionsIfNeeded(using: modelContext)
    }

    private static func seedDefaultCategoriesIfNeeded(using modelContext: ModelContext) throws {
        let descriptor = FetchDescriptor<TransactionCategory>()
        let existingCategories = try modelContext.fetch(descriptor)
        let existingLegacyKeys = Set(existingCategories.compactMap(\.legacyKey))
        var requiresSave = false

        for (index, legacyCategory) in Category.allCases.enumerated() {
            guard !existingLegacyKeys.contains(legacyCategory.rawValue) else { continue }

            modelContext.insert(
                TransactionCategory.makeDefault(from: legacyCategory, index: index)
            )
            requiresSave = true
        }

        if requiresSave {
            try modelContext.save()
        }

        UserDefaults.standard.set(true, forKey: didSeedCategoriesKey)
    }

    private static func migrateTransactionsIfNeeded(using modelContext: ModelContext) throws {
        let categories = try modelContext.fetch(FetchDescriptor<TransactionCategory>())
        let transactions = try modelContext.fetch(FetchDescriptor<Transaction>())
        let categoryPairs: [(String, TransactionCategory)] = categories.compactMap { category in
            guard let legacyKey = category.legacyKey else { return nil }
            return (legacyKey, category)
        }
        let categoryMap = Dictionary(uniqueKeysWithValues: categoryPairs)

        var requiresSave = false

        for transaction in transactions {
            if transaction.linkedCategory == nil {
                let migratedCategory = categoryMap[transaction.category.rawValue]
                transaction.assignCategory(migratedCategory, fallback: transaction.category)
                requiresSave = true
            } else if let linkedCategory = transaction.linkedCategory {
                transaction.assignCategory(linkedCategory, fallback: transaction.category)
                requiresSave = true
            }
        }

        if requiresSave {
            try modelContext.save()
        }
    }

    static func resetSeedFlag() {
        UserDefaults.standard.removeObject(forKey: didSeedCategoriesKey)
    }
}
