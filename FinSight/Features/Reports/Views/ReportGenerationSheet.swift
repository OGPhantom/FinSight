//
//  ReportGenerationSheet.swift
//  FinSight
//
//  Created by Никита Сторчай on 04.04.2026.
//

import SwiftUI

struct ReportGenerationSheet: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(SettingsStore.self) private var settings

    let transactions: [Transaction]
    let onGenerate: (DateInterval) -> Void

    @State private var selection: ReportGenerationOption = .last7Days
    @State private var customStartDate: Date = .now
    @State private var customEndDate: Date = .now

    private let calendar = Calendar.current

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 18) {
                    SectionTitle(text: "Selected timeframe")
                    heroCard

                    VStack(alignment: .leading, spacing: 12) {
                        SectionTitle(text: "Prepared Periods")

                        LazyVStack(spacing: 10) {
                            ForEach(ReportGenerationOption.allCases) { option in
                                optionRow(option)
                            }
                        }
                    }

                    if selection == .custom {
                        VStack(alignment: .leading, spacing: 12) {
                            SectionTitle(text: "Custom Range")

                            VStack(spacing: 10) {
                                pickerRow(
                                    title: "Start",
                                    symbol: "calendar",
                                    tint: .teal
                                ) {
                                    DatePicker(
                                        "",
                                        selection: $customStartDate,
                                        in: availableDateRange,
                                        displayedComponents: .date
                                    )
                                    .labelsHidden()
                                    .datePickerStyle(.compact)
                                    .tint(settings.appAccentColor.color)
                                }

                                pickerRow(
                                    title: "End",
                                    symbol: "calendar.badge.clock",
                                    tint: .orange
                                ) {
                                    DatePicker(
                                        "",
                                        selection: $customEndDate,
                                        in: customStartDate...availableDateRange.upperBound,
                                        displayedComponents: .date
                                    )
                                    .labelsHidden()
                                    .datePickerStyle(.compact)
                                    .tint(settings.appAccentColor.color)
                                }
                            }
                            .padding(12)
                            .background(cardBackground)
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 16)
                .padding(.bottom, 120)
            }
            .background(AppBackground())
            .scrollIndicators(.hidden)
            .navigationTitle("Generate Report")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Close") {
                        dismiss()
                    }
                    .font(.system(size: 16, weight: .semibold))
                }
            }
            .safeAreaInset(edge: .bottom) {
                bottomBar
            }
            .onAppear {
                let bounds = transactionBounds
                customStartDate = bounds.start
                customEndDate = bounds.end
            }
        }
    }
}

private extension ReportGenerationSheet {
    var availableDateRange: ClosedRange<Date> {
        transactionBounds.start...transactionBounds.end
    }

    var transactionBounds: (start: Date, end: Date) {
        let now = Date()
        let dates = transactions.map(\.date)
        let start = dates.min() ?? now
        let end = dates.max() ?? now
        return (start, end)
    }

    var resolvedInterval: DateInterval {
        switch selection {
        case .last7Days:
            let end = transactionBounds.end
            let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: end)) ?? transactionBounds.start
            return DateInterval(start: max(start, transactionBounds.start), end: transactionBounds.end)

        case .last30Days:
            let end = transactionBounds.end
            let start = calendar.date(byAdding: .day, value: -29, to: calendar.startOfDay(for: end)) ?? transactionBounds.start
            return DateInterval(start: max(start, transactionBounds.start), end: transactionBounds.end)

        case .last90Days:
            let end = transactionBounds.end
            let start = calendar.date(byAdding: .day, value: -89, to: calendar.startOfDay(for: end)) ?? transactionBounds.start
            return DateInterval(start: max(start, transactionBounds.start), end: transactionBounds.end)

        case .allTime:
            return DateInterval(start: transactionBounds.start, end: transactionBounds.end)

        case .custom:
            let start = calendar.startOfDay(for: customStartDate)
            let end = calendar.date(
                bySettingHour: 23,
                minute: 59,
                second: 59,
                of: customEndDate
            ) ?? customEndDate
            return DateInterval(start: start, end: end)
        }
    }

    var heroCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 12) {
                Text(intervalLabel(resolvedInterval))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)

                Spacer(minLength: 12)

                Image(systemName: "sparkles.rectangle.stack")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.16))
                    .clipShape(Circle())
            }

            VStack(alignment: .leading, spacing: 4) {
                Text("Transactions in range")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))

                Text("\(transactions(in: resolvedInterval).count)")
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }
            .padding(.bottom, 8)

            HStack(spacing: 10) {
                heroPill(
                    title: selection.title,
                    subtitle: "Mode"
                )

                Spacer()

                heroPill(
                    title: canGenerate ? "Ready to generate" : "No transactions",
                    subtitle: "Status"
                )
            }
        }
        .padding(20)
        .background(heroBackground)
    }

    var heroBackground: some View {
        RoundedRectangle(cornerRadius: 28, style: .continuous)
            .fill(
                LinearGradient(
                    colors: [
                        settings.appAccentColor.color.opacity(0.95),
                        settings.appAccentColor.color.opacity(0.7),
                        Color.black.opacity(0.18)
                    ],
                    startPoint: .topLeading,
                    endPoint: .bottomTrailing
                )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 28, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(
                color: settings.appAccentColor.color.opacity(0.22),
                radius: 14,
                x: 0,
                y: 8
            )
    }

    var bottomBar: some View {
        VStack(spacing: 0) {
            Divider()
                .overlay(Color.primary.opacity(0.06))

            Button {
                onGenerate(resolvedInterval)
                dismiss()
            } label: {
                Text("GENERATE REPORT")
                    .font(.system(size: 16, weight: .bold))
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(
                        RoundedRectangle(cornerRadius: 18, style: .continuous)
                            .fill(
                                canGenerate
                                ? settings.appAccentColor.color
                                : Color.primary.opacity(0.14)
                            )
                    )
                    .foregroundStyle(canGenerate ? .white : .secondary)
            }
            .buttonStyle(.plain)
            .disabled(!canGenerate)
            .padding(.horizontal, 20)
            .padding(.top, 12)
            .padding(.bottom, 8)
        }
        .background(.ultraThinMaterial)
    }

    var canGenerate: Bool {
        !transactions(in: resolvedInterval).isEmpty
    }

    var cardBackground: some View {
        RoundedRectangle(cornerRadius: 24, style: .continuous)
            .fill(Color(.systemBackground).opacity(0.9))
            .overlay(
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .stroke(Color.primary.opacity(0.06), lineWidth: 1)
            )
    }

    func heroPill(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(subtitle)
                .font(.caption2.weight(.semibold))
                .foregroundStyle(.white.opacity(0.72))

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.white)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.white.opacity(0.12))
                .overlay(
                    RoundedRectangle(cornerRadius: 18, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        )
    }

    func optionRow(_ option: ReportGenerationOption) -> some View {
        let isSelected = selection == option

        return Button {
            withAnimation(.spring(response: 0.28, dampingFraction: 0.88)) {
                selection = option
            }
        } label: {
            HStack(spacing: 14) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill((isSelected ? settings.appAccentColor.color : Color.primary).opacity(isSelected ? 0.14 : 0.05))

                    Image(systemName: option.symbol)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(isSelected ? settings.appAccentColor.color : .primary)
                }
                .frame(width: 42, height: 42)

                VStack(alignment: .leading, spacing: 3) {
                    Text(option.title)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(optionSubtitle(option))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(.secondary)
                }

                Spacer(minLength: 12)

                if isSelected {
                    Image(systemName: "checkmark")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(settings.appAccentColor.color)
                        .frame(width: 28, height: 28)
                        .background(
                            Circle()
                                .fill(settings.appAccentColor.color.opacity(0.14))
                        )
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 14)
            .background(cardBackground)
        }
        .buttonStyle(.plain)
    }

    @ViewBuilder
    func pickerRow<Content: View>(
        title: String,
        symbol: String,
        tint: Color,
        @ViewBuilder trailing: () -> Content
    ) -> some View {
        HStack(spacing: 12) {
            ZStack {
                RoundedRectangle(cornerRadius: 12, style: .continuous)
                    .fill(tint.opacity(0.14))

                Image(systemName: symbol)
                    .font(.system(size: 13, weight: .bold))
                    .foregroundStyle(tint)
            }
            .frame(width: 34, height: 34)

            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundStyle(.primary)

            Spacer(minLength: 12)

            trailing()
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.primary.opacity(0.035))
        )
    }

    func transactions(in interval: DateInterval) -> [Transaction] {
        transactions.filter { transaction in
            transaction.date >= interval.start && transaction.date <= interval.end
        }
    }

    func intervalLabel(_ interval: DateInterval) -> String {
        let start = interval.start.formatted(date: .abbreviated, time: .omitted)
        let end = interval.end.formatted(date: .abbreviated, time: .omitted)
        return "\(start) – \(end)"
    }

    func optionSubtitle(_ option: ReportGenerationOption) -> String {
        switch option {
        case .last7Days:
            return "A compact weekly briefing"
        case .last30Days:
            return "A fuller monthly-style view"
        case .last90Days:
            return "Quarter-scale spending patterns"
        case .allTime:
            return "Everything currently recorded"
        case .custom:
            return "Pick any start and end date"
        }
    }
}
