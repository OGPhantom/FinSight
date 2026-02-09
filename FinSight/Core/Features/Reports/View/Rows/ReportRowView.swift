//
//  ReportRowView.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import SwiftUI

struct ReportRowView: View {
    let report: WeeklyReport

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(reportDateRange)
                .font(.headline)

            Text(report.overview)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .padding()
        .background(CardBackground())
        .listRowInsets(EdgeInsets(top: 6, leading: 16, bottom: 6, trailing: 16))
        .listRowSeparator(.hidden)
        .listRowBackground(Color.clear)
    }

    private var reportDateRange: String {
        "\(report.startDate.formatted(date: .abbreviated, time: .omitted)) – \(report.endDate.formatted(date: .abbreviated, time: .omitted))"
    }
}

#Preview {
    ReportRowView(report: .mock)
}
