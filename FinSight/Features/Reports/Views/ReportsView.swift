//
//  ReportsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 08.02.2026.
//

import SwiftUI
import SwiftData
import FoundationModels

struct ReportsView: View {
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \WeeklyReport.createdAt, order: .forward)
    private var reports: [WeeklyReport]

    @State private var viewModel = ReportsViewModel()

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
                Task {
                    await viewModel.generateWeeklyReport(using: modelContext)
                }
            }, image: "sparkles")
        }
        .alert("Model Unavailable", isPresented: $viewModel.showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(viewModel.alertMessage)
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
                    Task {
                        await viewModel.generateWeeklyReport(using: modelContext)
                    }
                } label: {
                    if viewModel.isLoading {
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
}

#Preview {
    ReportsView()
}
