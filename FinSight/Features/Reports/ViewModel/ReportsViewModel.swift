//
//  ReportsViewModel.swift
//  FinSight
//
//  Created by Никита Сторчай on 28.02.2026.
//


import Foundation
import SwiftData
import FoundationModels

@Observable
final class ReportsViewModel {

    var isLoading = false
    var showAlert = false
    var alertMessage = ""

    private let summarizer: FinanceSummarizer

    init(summarizer: FinanceSummarizer = FinanceSummarizer()) {
        self.summarizer = summarizer
    }

    func generateCustomReport(using modelContext: ModelContext) async {
        guard !isLoading else { return }

        isLoading = true
        defer { isLoading = false }

        do {
            let descriptor = FetchDescriptor<Transaction>()
            let transactions = try modelContext.fetch(descriptor)

            guard !transactions.isEmpty else {
                return
            }

            let input = FinanceSummaryInput(from: transactions)

            guard summarizer.isAvailable else {
                handleModelUnavailable(reason: summarizer.availabilityReason)
                return
            }

            let output = try await summarizer.summarize(input)

            let report = CustomReport (
                startDate: input.startDate,
                endDate: input.endDate,
                totalSpent: input.totalSpent,
                totalsByCategory: input.totalsByCategory,
                flaggedCategories: input.flaggedCategories,
                topMerchants: input.topMerchants,
                overview: output.overview,
                keyInsights: output.keyInsights,
                recommendations: output.recommendations
            )

            modelContext.insert(report)
            try modelContext.save()

        } catch {
            alertMessage = "The AI model failed to generate a summary. Please try again."
            showAlert = true
        }
    }

    private func handleModelUnavailable(reason: SystemLanguageModel.Availability) {
        switch reason {
        case .available:
            assertionFailure("handleModelUnavailable called while model is available")
        case .unavailable(.deviceNotEligible):
            alertMessage = "This device does not support Apple Intelligence features."
        case .unavailable(.appleIntelligenceNotEnabled):
            alertMessage = "Apple Intelligence is disabled. Please enable it in Settings."
        case .unavailable(.modelNotReady):
            alertMessage = "The AI model is still preparing. Please try again in a few moments."
        case .unavailable(_):
            alertMessage = "Model is unavailable. Reason: \(reason)."
        }

        showAlert = true
    }
}
