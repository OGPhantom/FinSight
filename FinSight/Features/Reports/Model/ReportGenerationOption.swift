//
//  ReportGenerationOption.swift
//  FinSight
//
//  Created by Никита Сторчай on 04.04.2026.
//


enum ReportGenerationOption: String, CaseIterable, Identifiable {
    case last7Days
    case last30Days
    case last90Days
    case allTime
    case custom

    var id: String { rawValue }

    var title: String {
        switch self {
        case .last7Days:
            return "Last 7 Days"
        case .last30Days:
            return "Last 30 Days"
        case .last90Days:
            return "Last 90 Days"
        case .allTime:
            return "All Time"
        case .custom:
            return "Custom Range"
        }
    }

    var symbol: String {
        switch self {
        case .last7Days:
            return "calendar.badge.clock"
        case .last30Days:
            return "calendar"
        case .last90Days:
            return "calendar.badge.exclamationmark"
        case .allTime:
            return "clock.arrow.trianglehead.counterclockwise.rotate.90"
        case .custom:
            return "slider.horizontal.3"
        }
    }
}
