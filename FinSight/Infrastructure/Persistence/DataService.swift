//
//  DataService.swift
//  FinSight
//
//  Created by Никита Сторчай on 31.03.2026.
//


import SwiftData

@MainActor
final class DataService {
    static let shared = DataService()

    private init() {}

    func resetAllData(context: ModelContext) {
        do {
            try context.save()

            try context.delete(model: Transaction.self)
            try context.delete(model: CustomReport.self)
            try context.delete(model: TransactionCategory.self)

            try context.save()

            CategoryMigrationService.resetSeedFlag()
            try CategoryMigrationService.prepare(using: context)
            try context.save()
        } catch {
            print("Failed to reset database: \(error)")
        }
    }
}
