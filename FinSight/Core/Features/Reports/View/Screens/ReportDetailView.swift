//
//  ReportDetailView.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import SwiftUI

struct ReportDetailView: View {
    let report: WeeklyReport

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                VStack(alignment: .leading,spacing: 6) {
                    Text("Time period")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(reportDateRange)
                        .font(.title3.weight(.semibold))
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                VStack(alignment: .leading,spacing: 6) {
                    Text("Total spent")
                        .font(.caption)
                        .foregroundStyle(.secondary)

                    Text(report.totalSpent, format: .currency(code: "USD"))
                        .font(.largeTitle.weight(.bold))
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(CardBackground())

                Text("Overview")
                    .font(.title3.bold())

                // MARK: Flagged Categories
                if !report.flaggedCategories.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Flagged Categories")
                            .font(.headline)

                        ForEach(
                            report.flaggedCategories.sorted(by: { $0.value > $1.value }),
                            id: \.key
                        ) { category, amount in
                            HStack {
                                CategoryIcon(category: category)

                                Text(category.displayName)
                                    .font(.subheadline)

                                Spacer()

                                Text(amount, format: .currency(code: "USD"))
                                    .font(.subheadline.weight(.semibold))
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(CardBackground())
                }

                // MARK: Overview
                VStack(alignment: .leading, spacing: 10) {
                    Text("Overview")
                        .font(.headline)

                    Text(report.overview)
                        .font(.body)
                        .foregroundStyle(.primary)
                }
                .padding()
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(CardBackground())

                // MARK: Key Insights
                if !report.keyInsights.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Key Insights")
                            .font(.headline)

                        ForEach(report.keyInsights, id: \.self) { insight in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "sparkles")
                                    .foregroundStyle(.purple)

                                Text(insight)
                                    .font(.body)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(CardBackground())
                }

                // MARK: Recommendations
                if !report.recommendations.isEmpty {
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Recommendations")
                            .font(.headline)

                        ForEach(report.recommendations, id: \.self) { recommendation in
                            HStack(alignment: .top, spacing: 10) {
                                Image(systemName: "checkmark.circle.fill")
                                    .foregroundStyle(.green)

                                Text(recommendation)
                                    .font(.body)
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(CardBackground())
                }
            }
            .padding()
        }
        .background(AppBackground())
        .navigationTitle("Report")
    }
}

private extension ReportDetailView {
    var reportDateRange: String {
        "\(report.startDate.formatted(date: .abbreviated, time: .omitted)) – \(report.endDate.formatted(date: .abbreviated, time: .omitted))"
    }
}

#Preview {
    ReportDetailView(report: .mock)
}
