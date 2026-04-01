//
//  AnalyticsView.swift
//  FinSight
//
//  Created by OpenAI on 01.04.2026.
//

import SwiftUI
import SwiftData
import Charts

struct AnalyticsView: View {
    @Environment(SettingsStore.self) private var settings
    @Query(sort: \Transaction.date, order: .reverse) private var transactions: [Transaction]

    @State private var viewModel = AnalyticsViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                periodPicker

                if transactions.isEmpty {
                    emptyState(
                        title: "No Analytics Yet",
                        subtitle: "Add transactions first. Analytics comes alive once the app has spending data to study.",
                        symbol: "chart.line.downtrend.xyaxis"
                    )
                } else if filteredTransactions.isEmpty {
                    emptyState(
                        title: "No Activity In This Period",
                        subtitle: "Try another timeframe to explore your spending patterns and comparisons.",
                        symbol: "calendar.badge.exclamationmark"
                    )
                } else {
                    summaryCard
                    spendingFlowCard
                    metricsGrid
                    categoryBreakdownCard
                    merchantBreakdownCard
                    weekdayRhythmCard
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(AppBackground())
        .navigationTitle("Analytics")
    }
}

// MARK: - Derived Data
private extension AnalyticsView {
    private var filteredTransactions: [Transaction] {
        viewModel.filteredTransactions(from: transactions)
    }

    private var chartPoints: [AnalyticsChartPoint] {
        viewModel.chartPoints(from: filteredTransactions)
    }

    private var categoryBreakdown: [AnalyticsCategorySummary] {
        viewModel.categoryBreakdown(from: filteredTransactions)
    }

    private var merchantBreakdown: [AnalyticsMerchantSummary] {
        viewModel.merchantBreakdown(from: filteredTransactions)
    }

    private var weekdayBreakdown: [AnalyticsWeekdaySummary] {
        viewModel.weekdayBreakdown(from: filteredTransactions)
    }
}

// MARK: - Period Picker
private extension AnalyticsView {
    var periodPicker: some View {
        HStack(spacing: 8) {
            ForEach(AnalyticsPeriod.allCases) { period in
                let isSelected = viewModel.selectedPeriod == period

                Button {
                    withAnimation(.spring(response: 0.28, dampingFraction: 0.9)) {
                        viewModel.selectedPeriod = period
                    }
                } label: {
                    Text(period.title)
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundStyle(isSelected ? .white : .primary)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 10)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(
                                    isSelected
                                    ? AnyShapeStyle(settings.appAccentColor.color.gradient)
                                    : AnyShapeStyle(Color.primary.opacity(0.05))
                                )
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(6)
        .background(CardBackground(cornerRadius: 20))
    }
}

// MARK: - Summary Card
private extension AnalyticsView {
    var summaryCard: some View {
        VStack(alignment: .leading, spacing: 18) {

            VStack(alignment: .leading, spacing: 6) {
                           Text("SPENDING SNAPSHOT")
                               .font(.system(size: 12, weight: .semibold))
                               .foregroundStyle(.secondary)
                               .tracking(0.8)

                           Text(viewModel.periodDescription())
                               .font(.subheadline)
                               .foregroundStyle(.secondary)
                       }

            VStack(alignment: .leading, spacing: 4) {
                Text("Total spent")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(
                    viewModel.totalSpent(from: filteredTransactions),
                    format: .currency(code: settings.currencyCode)
                )
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.82)
            }

            HStack(spacing: 10) {
                spotlightPill(
                    title: "\(filteredTransactions.count)",
                    subtitle: "transactions"
                )

                Spacer()

                spotlightPill(
                    title: viewModel.selectedPeriod.subtitle,
                    subtitle: "window"
                )
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading) // ← ключевая строка
        .padding(20)
        .background(CardBackground(cornerRadius: 28))
    }

    var spendingFlowCard: some View {
        AnalyticsSectionCard(
            title: "SPENDING FLOW",
            subtitle: "How your expenses moved through the selected timeframe."
        ) {
            VStack(alignment: .leading, spacing: 18) {
                Chart {
                    ForEach(chartPoints) { point in
                        AreaMark(
                            x: .value("Date", point.date),
                            y: .value("Amount", point.amount)
                        )
                        .foregroundStyle(chartGradient)
                        .interpolationMethod(.catmullRom)

                        LineMark(
                            x: .value("Date", point.date),
                            y: .value("Amount", point.amount)
                        )
                        .foregroundStyle(settings.appAccentColor.color)
                        .lineStyle(StrokeStyle(lineWidth: 3, lineCap: .round, lineJoin: .round))
                        .interpolationMethod(.catmullRom)
                    }

                    if let peakPoint = chartPoints.max(by: { $0.amount < $1.amount }) {
                        PointMark(
                            x: .value("Peak", peakPoint.date),
                            y: .value("Amount", peakPoint.amount)
                        )
                        .symbolSize(64)
                        .foregroundStyle(settings.appAccentColor.color)
                    }
                }
                .frame(height: 220)
                .chartLegend(.hidden)
                .chartYAxis(.hidden)
                .chartXAxis {
                    AxisMarks(values: .automatic(desiredCount: viewModel.selectedPeriod == .year ? 6 : 5)) { value in
                        AxisGridLine(stroke: StrokeStyle(lineWidth: 0.5, dash: [3, 4]))
                            .foregroundStyle(Color.primary.opacity(0.08))

                        AxisValueLabel {
                            if let date = value.as(Date.self) {
                                Text(axisLabel(for: date))
                                    .font(.caption2)
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                }

                HStack(spacing: 12) {
                    chartStat(
                        title: "Peak day",
                        value: peakDayValue
                    )

                    chartStat(
                        title: "Average/day",
                        value: metricValueText(
                            value: viewModel.averageDailySpend(from: filteredTransactions),
                            valueText: nil,
                            isCurrency: true
                        )
                    )
                }
            }
        }
    }

    var metricsGrid: some View {
        LazyVGrid(columns: gridColumns, spacing: 12) {
            metricCard(
                title: "Average daily spend",
                value: viewModel.averageDailySpend(from: filteredTransactions),
                systemImage: "calendar",
                isCurrency: true
            )

            metricCard(
                title: "Biggest day",
                value: viewModel.biggestSpendingDay(from: filteredTransactions)?.amount ?? 0,
                systemImage: "flame.fill",
                isCurrency: true,
                detail: biggestDayDetail
            )

            metricCard(
                title: "Transactions",
                valueText: "\(filteredTransactions.count)",
                systemImage: "list.bullet.rectangle",
                detail: viewModel.selectedPeriod.subtitle
            )

            metricCard(
                title: "Top category",
                valueText: viewModel.topCategory(from: filteredTransactions)?.category.displayName ?? "None",
                systemImage: "square.grid.2x2.fill",
                detail: categoryShareDetail
            )
        }
    }

    var categoryBreakdownCard: some View {
        AnalyticsSectionCard(
            title: "CATEGORY RANKING",
            subtitle: "Which areas absorbed the most spend."
        ) {
            VStack(spacing: 14) {
                ForEach(categoryBreakdown) { item in
                    HStack(spacing: 12) {
                        CategoryIcon(category: item.category)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(item.category.displayName)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)

                            ProgressView(value: item.share)
                                .tint(item.category.iconInfo.color)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Spacer(minLength: 12)

                        VStack(alignment: .trailing, spacing: 3) {
                            Text(item.amount, format: .currency(code: settings.currencyCode))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(percentText(item.share))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    var merchantBreakdownCard: some View {
        AnalyticsSectionCard(
            title: "MERCHANT RANKING",
            subtitle: "The places with the highest impact on your spending."
        ) {
            VStack(spacing: 14) {
                ForEach(merchantBreakdown) { merchant in
                    HStack(spacing: 12) {
                        IconBadge(systemName: "building.2.crop.circle.fill", color: settings.appAccentColor.color)

                        VStack(alignment: .leading, spacing: 4) {
                            Text(merchant.merchant)
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)
                                .lineLimit(1)

                            ProgressView(value: merchant.share)
                                .tint(settings.appAccentColor.color)
                                .frame(maxWidth: .infinity, alignment: .leading)
                        }

                        Spacer(minLength: 12)

                        VStack(alignment: .trailing, spacing: 3) {
                            Text(merchant.amount, format: .currency(code: settings.currencyCode))
                                .font(.subheadline.weight(.semibold))
                                .foregroundStyle(.primary)

                            Text(percentText(merchant.share))
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
    }

    var weekdayRhythmCard: some View {
        AnalyticsSectionCard(
            title: "WEEKDAY RHYTHM",
            subtitle: "How your spending intensity changes across the week."
        ) {
            VStack(spacing: 12) {
                ForEach(weekdayBreakdown) { day in
                    HStack(spacing: 12) {
                        Text(day.label.uppercased())
                            .font(.system(size: 11, weight: .semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 32, alignment: .leading)

                        GeometryReader { geometry in
                            ZStack(alignment: .leading) {
                                Capsule()
                                    .fill(Color.primary.opacity(0.05))

                                Capsule()
                                    .fill(settings.appAccentColor.color.gradient)
                                    .frame(width: max(8, geometry.size.width * day.share))
                            }
                        }
                        .frame(height: 10)

                        Text(day.amount, format: .currency(code: settings.currencyCode))
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                            .frame(width: 72, alignment: .trailing)
                    }
                }
            }
        }
    }

    var peakDayValue: String {
        guard let biggestDay = viewModel.biggestSpendingDay(from: filteredTransactions) else {
            return "No data"
        }

        return biggestDay.amount.formatted(.currency(code: settings.currencyCode))
    }

    var biggestDayDetail: String {
        guard let biggestDay = viewModel.biggestSpendingDay(from: filteredTransactions) else {
            return "No activity"
        }

        return biggestDay.date.formatted(.dateTime.month(.abbreviated).day())
    }

    var categoryShareDetail: String {
        guard let topCategory = viewModel.topCategory(from: filteredTransactions) else {
            return "No activity"
        }

        return percentText(topCategory.share)
    }

    var chartGradient: LinearGradient {
        LinearGradient(
            colors: [
                settings.appAccentColor.color.opacity(0.34),
                settings.appAccentColor.color.opacity(0.06)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    var gridColumns: [GridItem] {
        [
            GridItem(.flexible(), spacing: 12),
            GridItem(.flexible(), spacing: 12)
        ]
    }

    func metricCard(
        title: String,
        value: Double? = nil,
        valueText: String? = nil,
        systemImage: String,
        isCurrency: Bool = false,
        detail: String? = nil
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(settings.appAccentColor.color.opacity(0.12))

                Image(systemName: systemImage)
                    .font(.system(size: 14, weight: .bold))
                    .foregroundStyle(settings.appAccentColor.color)
            }
            .frame(width: 40, height: 40)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)

                Text(metricValueText(value: value, valueText: valueText, isCurrency: isCurrency))
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.primary)
                    .lineLimit(2)
                    .minimumScaleFactor(0.84)

                if let detail {
                    Text(detail)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .lineLimit(1)
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(CardBackground(cornerRadius: 22))
    }

    func spotlightPill(title: String, subtitle: String) -> some View {
        VStack(alignment: .leading, spacing: 2) {
            Text(subtitle.uppercased())
                .font(.system(size: 10, weight: .semibold))
                .foregroundStyle(.secondary)
                .tracking(0.8)

            Text(title)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(
            Capsule()
                .fill(Color.primary.opacity(0.05))
        )
    }

    func chartStat(title: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            Text(value)
                .font(.subheadline.weight(.semibold))
                .foregroundStyle(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(Color.primary.opacity(0.04))
        )
    }

    func metricValueText(value: Double?, valueText: String?, isCurrency: Bool) -> String {
        if let valueText {
            return valueText
        }

        guard let value else {
            return "No data"
        }

        if isCurrency {
            return value.formatted(.currency(code: settings.currencyCode))
        }

        return value.formatted()
    }

    func axisLabel(for date: Date) -> String {
        switch viewModel.selectedPeriod {
        case .week:
            return date.formatted(.dateTime.weekday(.narrow))
        case .month:
            return date.formatted(.dateTime.day())
        case .quarter:
            return date.formatted(.dateTime.month(.abbreviated))
        case .year:
            return date.formatted(.dateTime.month(.abbreviated))
        }
    }

    func percentText(_ share: Double) -> String {
        "\(Int((share * 100).rounded()))%"
    }

    func emptyState(title: String, subtitle: String, symbol: String) -> some View {
        VStack(spacing: 18) {
            ZStack {
                RoundedRectangle(cornerRadius: 24, style: .continuous)
                    .fill(settings.appAccentColor.color.opacity(0.14))
                    .frame(width: 82, height: 82)

                Image(systemName: symbol)
                    .font(.system(size: 30, weight: .semibold))
                    .foregroundStyle(settings.appAccentColor.color)
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.title3.weight(.bold))
                    .foregroundStyle(.primary)

                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(3)
            }
        }
        .padding(24)
        .frame(maxWidth: .infinity)
        .background(CardBackground(cornerRadius: 28))
    }
}

#Preview {
    NavigationStack {
        AnalyticsView()
            .environment(SettingsStore())
    }
}
