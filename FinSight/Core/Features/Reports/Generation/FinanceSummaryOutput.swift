//
//  FinanceSummaryOutput.swift
//  FinSight
//
//  Created by Никита Сторчай on 07.02.2026.
//

import FoundationModels

@Generable
struct FinanceSummaryOutput {
    @Guide(description: "An overview of the finance summary input.")
    var overview: String

    @Guide(description: "3-5 bullets highlighting trends, spikes, or category/merchant insights.")
    var keyInsights: [String]

    @Guide(description: "2-3 specific, practical recommendations tied to the week's data.")
    var recommendations: [String]
}

extension FinanceSummaryOutput {
    static var mock: FinanceSummaryOutput {
        FinanceSummaryOutput(
            overview: "Spending rose mid-week, driven by travel and utilities. Essentials like groceries and transport remained steady, while discretionary categories stayed moderate overall.",
            keyInsights: [
                "Travel was the highest category at $243, reflecting a weekend fare.",
                "Utilities were elevated at $210; consider checking for seasonal spikes or billing changes.",
                "Groceries remained consistent at $154 with a single larger trip early in the week.",
                "Dining and entertainment combined were under $160, indicating controlled discretionary spend.",
                "Amazon accounted for a notable one-time purchase of $129.99."
            ],
            recommendations: [
                "Set a monthly cap for utilities and enable usage alerts to catch spikes early.",
                "Bundle travel expenses where possible (loyalty programs, advance booking) to reduce fares.",
                "Plan a meal prep day to trim dining spend by 10–15% next week."
            ]
        )
    }
}
