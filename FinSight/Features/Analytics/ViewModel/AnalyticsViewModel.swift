//
//  AnalyticsViewModel.swift
//  FinSight
//
//  Created by OpenAI on 01.04.2026.
//

import Foundation

@Observable
final class AnalyticsViewModel {
    var selectedPeriod: AnalyticsPeriod = .month

    private let calendar = Calendar.current

    func filteredTransactions(from transactions: [Transaction], now: Date = .now) -> [Transaction] {
        let interval = selectedPeriod.interval(now: now, calendar: calendar)

        return transactions
            .filter { $0.date >= interval.start && $0.date <= interval.end }
            .sorted { $0.date < $1.date }
    }

    func totalSpent(from transactions: [Transaction]) -> Double {
        transactions.reduce(0) { $0 + $1.amount }
    }

    func averageDailySpend(from transactions: [Transaction], now: Date = .now) -> Double {
        let total = totalSpent(from: transactions)
        let interval = selectedPeriod.interval(now: now, calendar: calendar)
        let elapsedDays = (calendar.dateComponents([.day], from: interval.start, to: now).day ?? 0) + 1
        let dayCount = max(1, elapsedDays)
        return total / Double(dayCount)
    }

    func biggestSpendingDay(from transactions: [Transaction]) -> AnalyticsDailySpend? {
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.startOfDay(for: transaction.date)
        }

        return grouped
            .map { date, values in
                AnalyticsDailySpend(date: date, amount: values.reduce(0) { $0 + $1.amount })
            }
            .max { lhs, rhs in
                lhs.amount < rhs.amount
            }
    }

    func topCategory(from transactions: [Transaction]) -> AnalyticsCategorySummary? {
        categoryBreakdown(from: transactions).first
    }

    func chartPoints(from transactions: [Transaction], now: Date = .now) -> [AnalyticsChartPoint] {
        let interval = selectedPeriod.interval(now: now, calendar: calendar)
        let grouped = Dictionary(grouping: transactions) { transaction in
            bucketStartDate(for: transaction.date)
        }

        return timelineBuckets(in: interval)
            .map { date in
                let total = grouped[date, default: []].reduce(0) { $0 + $1.amount }
                return AnalyticsChartPoint(date: date, amount: total, period: selectedPeriod)
            }
    }

    func categoryBreakdown(from transactions: [Transaction]) -> [AnalyticsCategorySummary] {
        let total = max(totalSpent(from: transactions), 0.01)
        let grouped = Dictionary(grouping: transactions, by: \.category)

        return grouped
            .map { category, values in
                let amount = values.reduce(0) { $0 + $1.amount }
                return AnalyticsCategorySummary(
                    category: category,
                    amount: amount,
                    share: amount / total
                )
            }
            .sorted { lhs, rhs in
                lhs.amount > rhs.amount
            }
    }

    func merchantBreakdown(from transactions: [Transaction], limit: Int = 5) -> [AnalyticsMerchantSummary] {
        let total = max(totalSpent(from: transactions), 0.01)
        let grouped = Dictionary(grouping: transactions, by: \.merchant)

        return grouped
            .map { merchant, values in
                let amount = values.reduce(0) { $0 + $1.amount }
                return AnalyticsMerchantSummary(
                    merchant: merchant,
                    amount: amount,
                    share: amount / total
                )
            }
            .sorted { lhs, rhs in
                lhs.amount > rhs.amount
            }
            .prefix(limit)
            .map { $0 }
    }

    func weekdayBreakdown(from transactions: [Transaction]) -> [AnalyticsWeekdaySummary] {
        var weekdayTotals: [Int: Double] = [:]

        for transaction in transactions {
            let weekday = calendar.component(.weekday, from: transaction.date)
            weekdayTotals[weekday, default: 0] += transaction.amount
        }

        let maxAmount = weekdayTotals.values.max() ?? 0
        let orderedWeekdays = calendar.shortWeekdaySymbols

        return orderedWeekdays.enumerated().map { index, symbol in
            let weekday = calendar.firstWeekday + index
            let normalizedWeekday = weekday > 7 ? weekday - 7 : weekday
            let amount = weekdayTotals[normalizedWeekday, default: 0]

            return AnalyticsWeekdaySummary(
                label: symbol,
                amount: amount,
                share: maxAmount == 0 ? 0 : amount / maxAmount
            )
        }
    }

    func periodDescription(now: Date = .now) -> String {
        let interval = selectedPeriod.interval(now: now, calendar: calendar)
        return "\(interval.start.formatted(date: .abbreviated, time: .omitted)) – \(now.formatted(date: .abbreviated, time: .omitted))"
    }
}

private extension AnalyticsViewModel {
    func bucketStartDate(for date: Date) -> Date {
        switch selectedPeriod {
        case .week, .month:
            return calendar.startOfDay(for: date)
        case .quarter:
            return calendar.dateInterval(of: .weekOfYear, for: date)?.start ?? calendar.startOfDay(for: date)
        case .year:
            return calendar.dateInterval(of: .month, for: date)?.start ?? calendar.startOfDay(for: date)
        }
    }

    func timelineBuckets(in interval: DateInterval) -> [Date] {
        var dates: [Date] = []
        var cursor = bucketStartDate(for: interval.start)

        while cursor <= interval.end {
            dates.append(cursor)

            switch selectedPeriod {
            case .week, .month:
                cursor = calendar.date(byAdding: .day, value: 1, to: cursor) ?? interval.end.addingTimeInterval(1)
            case .quarter:
                cursor = calendar.date(byAdding: .weekOfYear, value: 1, to: cursor) ?? interval.end.addingTimeInterval(1)
            case .year:
                cursor = calendar.date(byAdding: .month, value: 1, to: cursor) ?? interval.end.addingTimeInterval(1)
            }
        }

        return dates
    }
}

struct AnalyticsChartPoint: Identifiable {
    let date: Date
    let amount: Double
    let period: AnalyticsPeriod

    var id: Date { date }

    var xAxisLabel: String {
        switch period {
        case .week:
            return date.formatted(.dateTime.weekday(.narrow))
        case .month:
            return date.formatted(.dateTime.day())
        case .quarter:
            return date.formatted(.dateTime.month(.abbreviated).day())
        case .year:
            return date.formatted(.dateTime.month(.abbreviated))
        }
    }
}

struct AnalyticsDailySpend {
    let date: Date
    let amount: Double
}

struct AnalyticsCategorySummary: Identifiable {
    let category: Category
    let amount: Double
    let share: Double

    var id: Category { category }
}

struct AnalyticsMerchantSummary: Identifiable {
    let merchant: String
    let amount: Double
    let share: Double

    var id: String { merchant }
}

struct AnalyticsWeekdaySummary: Identifiable {
    let label: String
    let amount: Double
    let share: Double

    var id: String { label }
}
