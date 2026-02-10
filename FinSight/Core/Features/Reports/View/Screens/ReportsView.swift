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
            ZStack {
                AppBackground()

                Group {
                    if reports.isEmpty {
                        emptyState
                    } else {
                        reportsList
                    }
                }
//                            .onAppear {
//                                loadWeeklyReportsMocks()
//                            }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .background(Color.clear)
                .navigationTitle("Reports")
                .toolbar { toolbar }
            }
        }
        .overlay(alignment: .bottomTrailing) {
            ActionButton(action: {
                generateWeeklyReport()
            }, image: "sparkles")
        }
    }
}

private extension ReportsView {
    var emptyState: some View {
        ContentUnavailableView("No reports", systemImage: "tray", description: Text("Generate your first report to get started"))
            .padding()
    }

    var reportsList: some View {
        List {
            ForEach(reports) {report in
                NavigationLink {
                    ReportDetailView(report: report)
                } label: {
                    ReportRowView(report: report)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .onDelete(perform: deleteReport)
        }
        .navigationLinkIndicatorVisibility(.hidden)
        .listStyle(.plain)
        .scrollContentBackground(.hidden)
    }

    var toolbar: some ToolbarContent {
        Group {
            ToolbarItem(placement: .topBarLeading) {
               EditButton()
                    .font(.system(size: 18, weight: .semibold))
            }

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

private extension ReportsView {
    func deleteReport(at offsets: IndexSet) {
        for index in offsets {
            let report = reports[index]
            modelContext.delete(report)
        }
    }
    
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
                    totalSpent: input.totalSpent,
                    totalsByCategory: input.totalsByCategory,
                    flaggedCategories: input.flaggedCategories,
                    topMerchants: input.topMerchants,
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
