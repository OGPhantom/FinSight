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
            Text(report.dateRangeText)
                .font(.headline)

            Text(report.overview)
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .lineLimit(2)
        }
        .modifier(CardRowModifier())
    }
}

#Preview {
    ReportRowView(report: .mock)
}
