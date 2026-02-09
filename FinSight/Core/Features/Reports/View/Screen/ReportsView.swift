//
//  ReportsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 08.02.2026.
//

import SwiftUI
import SwiftData

struct ReportsView: View {
    @Environment(\.modelContext) private var modelContext
    @State private var isLoading = false

    @Query(sort: \WeeklyReport.createdAt, order: .forward)
    private var reports: [WeeklyReport]

    var body: some View {
        NavigationStack {
            List {
                ForEach(reports) {report in
                    ReportRowView(report: report)
                }
            }
//            .onAppear {
//                loadWeeklyReportsMocks()
//            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .background(Color.clear)
            .navigationTitle("Reports")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        generateWeeklyReport()
                    } label: {
                        if isLoading {
                            ProgressView()
                        } else {
                            Image(systemName: "sparkles")
                        }
                    }
                }
            }
        }
    }
}


private extension ReportsView {
    func loadWeeklyReportsMocks() {
        let reports = WeeklyReport.mocks
        for report in reports {
            modelContext.insert(report)
        }
    }

    func generateWeeklyReport() {
        guard !isLoading else { return }

        Task {
            isLoading = true
            defer {
                isLoading = false
            }
            do {
                let descriptor = FetchDescriptor<Transaction>()
                let transactions = try modelContext.fetch(descriptor)
                let input = FinanceSummaryInput(from: transactions)
                let financeSummarizer = FinanceSummarizer()
                let output = try await financeSummarizer.summarize(input)

                let report = WeeklyReport(
                    startDate: input.startDate,
                    endDate: input.endDate,
                    overview: output.overview,
                    keyInsights: output.keyInsights,
                    recommendations: output.recommendations
                )

                modelContext.insert(report)
            } catch {
                print("Fetch falied: \(error)")
            }
        }
    }
}

#Preview {
    ReportsView()
}
