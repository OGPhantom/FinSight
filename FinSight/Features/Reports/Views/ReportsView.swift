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
    @Environment(SettingsStore.self) private var settings
    @Query(sort: \CustomReport.startDate, order: .reverse)
    private var reports: [CustomReport]
    @Query private var transactions: [Transaction]

    @State private var viewModel = ReportsViewModel()
    @State private var showingGenerationSheet = false

    var body: some View {
        NavigationStack {
            ZStack {
                AppBackground()

                if reports.isEmpty {
                    emptyState
                } else {
                    ScrollView {
                        LazyVStack(alignment: .leading, spacing: 24) {
                            ForEach(reports) { report in
                                NavigationLink {
                                    ReportDetailView(report: report)
                                } label: {
                                    ReportRowView(report: report)
                                }
                                .buttonStyle(ReportCardButtonStyle())
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 16)
                        .padding(.bottom, 120)
                    }
                    .scrollIndicators(.hidden)
                }

                if viewModel.isLoading {
                    loadingOverlay
                }
            }
            .navigationTitle("Reports")
        }
        .overlay(alignment: .bottomTrailing) {
            generateButton
        }
        .sheet(isPresented: $showingGenerationSheet) {
            ReportGenerationSheet(transactions: transactions) { interval in
                let scopedTransactions = transactions(in: interval)

                Task {
                    await viewModel.generateCustomReport(
                        from: scopedTransactions,
                        using: modelContext
                    )
                }
            }
            .environment(settings)
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
        VStack(spacing: 20) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(settings.appAccentColor.color.opacity(0.14))
                    .frame(width: 82, height: 82)

                Image(systemName: "sparkles.rectangle.stack")
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(settings.appAccentColor.color)
            }

            VStack(spacing: 8) {
                Text("No Reports Yet")
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text(
                    transactions.isEmpty
                    ? "Add transactions first. Reports are generated from your recorded spending."
                    : "Generate your first briefing to turn raw expenses into insights and recommendations."
                )
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }

    var loadingOverlay: some View {
        ZStack {
            Color.black.opacity(0.08)
                .ignoresSafeArea()

            VStack(spacing: 14) {
                ProgressView()
                    .tint(settings.appAccentColor.color)
                    .scaleEffect(1.1)

                Text("Building your briefing...")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 18)
            .background(CardBackground(cornerRadius: 24))
        }
    }

    var generateButton: some View {
        ActionButton(action: {
            showingGenerationSheet = true
        }, image: "sparkles")
        .disabled(!canGenerateReport)
        .opacity(canGenerateReport ? 1 : 0.55)
    }

    var canGenerateReport: Bool {
        !transactions.isEmpty && !viewModel.isLoading
    }

    func loadCustomReportsMocks() {
        let reports = CustomReport.mocks

        for report in reports {
            modelContext.insert(report)
        }

        try? modelContext.save()
    }

    func transactions(in interval: DateInterval) -> [Transaction] {
        transactions.filter { transaction in
            transaction.date >= interval.start && transaction.date <= interval.end
        }
    }
}

private struct ReportCardButtonStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? 0.99 : 1)
            .brightness(configuration.isPressed ? -0.012 : 0)
            .animation(.easeOut(duration: 0.18), value: configuration.isPressed)
    }
}

#Preview {
    ReportsView()
        .environment(SettingsStore())
}
