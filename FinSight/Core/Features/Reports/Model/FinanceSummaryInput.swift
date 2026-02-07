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
    let totalsByCategory: [Transaction: Double]
    let flaggedCategories: [Transaction: Double]
    let topMerchants: [String: Double]
}
