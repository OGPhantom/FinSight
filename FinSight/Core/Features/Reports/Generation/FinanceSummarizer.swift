//
//  FinanceSummarizer.swift
//  FinSight
//
//  Created by Никита Сторчай on 08.02.2026.
//

import FoundationModels

struct FinanceSummarizer {
    let session = LanguageModelSession {
        """
        You are a finance advisor.
        You will receive input data about a user's financial transactions and are tasked with generating a financial summary.
        Here is an example of input: \(FinanceSummaryInput.mockThisWeek).
        Here is an example of output: \(FinanceSummaryOutput.mock).
        """
    }

    func summarize(_ input: FinanceSummaryInput) async throws -> FinanceSummaryOutput {
        let prompt =
        """
        Analyze the user's weekly financial data below and produce a concise, friendly summary.
        - Include a title
        - Write a 2–3 sentence overview of spending
        - List 3–5 key insights about trends or categories
        - Suggest 2–3 actionable recommendations to save money

        Data:
        Total spent: \(input.totalSpent)
        Categories: \(input.totalsByCategory.map { "\($0.key.displayName): \($0.value)" }.joined(separator: ", "))
        Flagged categories: \(input.flaggedCategories.map { "\($0.key.displayName): \($0.value)" }.joined(separator: ", "))
        Top merchants: \(input.topMerchants.map { "\($0.key): \($0.value)" }.joined(separator: ", "))
        Date range: \(input.startDate.formatted(date: .abbreviated, time: .omitted)) – \(input.endDate.formatted(date: .abbreviated, time: .omitted))
        """

        let output = try await session.respond(to: prompt, generating: FinanceSummaryOutput.self)
        print("DEBUG:\nOutput content:\n \(output.content)")
        return output.content
    }
}
