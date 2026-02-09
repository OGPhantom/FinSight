//
//  ReportDetailView.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import SwiftUI

struct ReportDetailView: View {
    let report: WeeklyReport

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("Overview")
                    .font(.title3.bold())

                Text(report.overview)

                Divider()

                Text("Key Insights")
                    .font(.title3.bold())

                ForEach(report.keyInsights, id: \.self) {
                    Label($0, systemImage: "circle.fill")
                }

                Divider()

                Text("Recommendations")
                    .font(.title3.bold())

                ForEach(report.recommendations, id: \.self) {
                    Label($0, systemImage: "sparkles")
                }
            }
            .padding()
        }
        .navigationTitle("Weekly Report")
    }
}

#Preview {
    ReportDetailView(report: .mock)
}
