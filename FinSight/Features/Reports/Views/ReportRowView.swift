//
//  ReportRowView.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import SwiftUI

struct ReportRowView: View {
    @Environment(SettingsStore.self) private var settings

    let report: CustomReport

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            SectionTitle(text: report.dateRangeText)
            VStack(alignment: .leading, spacing: 28) {
                header
                summary
                overview
            }
            .padding(18)
            .background(CardBackground(cornerRadius: 24))
        }
    }
}

private extension ReportRowView {
    var header: some View {
        HStack(alignment: .center, spacing: 12) {

            SectionTitle(text: "Custom Report")

            Spacer(minLength: 12)

            Image(systemName: "arrow.up.right")
                .font(.system(size: 13, weight: .bold))
                .foregroundStyle(settings.appAccentColor.color)
                .padding(10)
                .background(
                    Circle()
                        .fill(settings.appAccentColor.color.opacity(0.12))
                )
        }
    }

    var summary: some View {
        HStack(alignment: .center, spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                Text("Total spent")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white)

                Text(report.totalSpent, format: .currency(code: settings.currencyCode))
                    .font(.system(size: 32, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)
            }

            Spacer(minLength: 12)

            if let topCategory = report.topCategory {
                VStack(alignment: .trailing, spacing: 8) {
                    Text("Top category")
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white)

                    HStack{
                        CategoryIcon(category: topCategory.category)
                        Text(topCategory.category.displayName)
                            .font(.system(size: 16).weight(.semibold))
                            .foregroundStyle(.white)
                    }
                }
            }
        }
        .background(heroBackground)
    }

    var heroBackground: some View {
        RoundedRectangle(cornerRadius: 20, style: .continuous)
            .fill(settings.appAccentColor.color.opacity(0.95))
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(Color.white.opacity(0.1), lineWidth: 1)
            )
            .shadow(
                color: settings.appAccentColor.color.opacity(0.22),
                radius: 14,
                x: 0,
                y: 8
            )
            .padding(.horizontal, -8)
            .padding(.vertical, -14)
    }

    var overview: some View {
        Text(report.overview)
            .font(.body)
            .foregroundStyle(.primary)
            .lineLimit(3)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

#Preview {
    ReportRowView(report: .mock)
        .environment(SettingsStore())
}
