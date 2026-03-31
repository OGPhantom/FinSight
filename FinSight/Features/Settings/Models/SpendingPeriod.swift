//
//  SpendingPeriod.swift
//  FinSight
//
//  Created by Никита Сторчай on 30.03.2026.
//

import Foundation

enum SpendingPeriod {
    case week
    case month
    case year
    case all

    var title: String {
        switch self {
        case .week: return "Week"
        case .month: return "Month"
        case .year: return "Year"
        case .all: return "All Time"
        }
    }

    func matches(_ date: Date, now: Date, calendar: Calendar) -> Bool {
        switch self {
        case .all:
            return true

        case .year:
            return calendar.isDate(date, equalTo: now, toGranularity: .year)

        case .month:
            return calendar.isDate(date, equalTo: now, toGranularity: .month)

        case .week:
            return calendar.isDate(date, equalTo: now, toGranularity: .weekOfYear)
        }
    }
}
