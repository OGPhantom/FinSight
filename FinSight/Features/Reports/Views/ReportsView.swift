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
    @Query(sort: \WeeklyReport.startDate, order: .reverse)
    private var reports: [WeeklyReport]

    @State private var viewModel = ReportsViewModel()

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
                                .contextMenu {
                                    Button(role: .destructive) {
                                        deleteReport(report)
                                    } label: {
                                        Label("Delete", systemImage: "trash")
                                    }
                                }
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

                Text("Generate your first weekly briefing to turn raw expenses into insights and recommendations.")
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

                Text("Building your weekly briefing...")
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
            }
            .padding(.horizontal, 22)
            .padding(.vertical, 18)
            .background(CardBackground(cornerRadius: 24))
        }
    }

    var generateButton: some View {
        Button {
            Task {
                await viewModel.generateWeeklyReport(using: modelContext)
            }
        } label: {
            Group {
                if viewModel.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Image(systemName: "sparkles")
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 58, height: 58)
            .background(
                Circle()
                    .fill(settings.appAccentColor.color.gradient)
                    .shadow(
                        color: settings.appAccentColor.color.opacity(0.45),
                        radius: 10,
                        x: 0,
                        y: 6
                    )
            )
        }
        .buttonStyle(.plain)
        .disabled(viewModel.isLoading)
        .padding(.trailing, 20)
        .padding(.bottom, 10)
    }

    func deleteReport(_ report: WeeklyReport) {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.9)) {
            modelContext.delete(report)
        }

        try? modelContext.save()
    }

    func loadWeeklyReportsMocks() {
        let reports = WeeklyReport.mocks

        for report in reports {
            modelContext.insert(report)
        }

        try? modelContext.save()
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
