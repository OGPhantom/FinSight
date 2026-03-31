//
//  SettingsViewModel.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

@Observable
final class SettingsViewModel {
    var totalSpent: Double = 0

    var selectedPeriod: SpendingPeriod = .all

    func updateTotal(from transactions: [Transaction]) {
        let now = Date()
        let calendar = Calendar.current

        totalSpent = transactions
            .filter { selectedPeriod.matches($0.date, now: now, calendar: calendar) }
            .reduce(0) { $0 + $1.amount }
    }
}
