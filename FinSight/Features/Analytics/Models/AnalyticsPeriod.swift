//
//  AnalyticsPeriod.swift
//  FinSight
//
//  Created by OpenAI on 01.04.2026.
//

import Foundation

enum AnalyticsPeriod: String, CaseIterable, Identifiable {
    case week
    case month
    case quarter
    case year

    var id: Self { self }

    var title: String {
        switch self {
        case .week:
            return "Week"
        case .month:
            return "Month"
        case .quarter:
            return "3M"
        case .year:
            return "Year"
        }
    }

    var subtitle: String {
        switch self {
        case .week:
            return "Last 7 days"
        case .month:
            return "This month"
        case .quarter:
            return "Last 3 months"
        case .year:
            return "This year"
        }
    }

    func interval(now: Date, calendar: Calendar) -> DateInterval {
        let end = now

        switch self {
        case .week:
            let start = calendar.date(byAdding: .day, value: -6, to: calendar.startOfDay(for: end)) ?? end
            return DateInterval(start: start, end: end)

        case .month:
            let start = calendar.dateInterval(of: .month, for: end)?.start ?? calendar.startOfDay(for: end)
            return DateInterval(start: start, end: end)

        case .quarter:
            let shiftedDate = calendar.date(byAdding: .month, value: -2, to: end) ?? end
            let start = calendar.dateInterval(of: .month, for: shiftedDate)?.start ?? calendar.startOfDay(for: shiftedDate)
            return DateInterval(start: start, end: end)

        case .year:
            let start = calendar.dateInterval(of: .year, for: end)?.start ?? calendar.startOfDay(for: end)
            return DateInterval(start: start, end: end)
        }
    }
}
