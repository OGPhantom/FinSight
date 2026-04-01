//
//  ReportDetailView.swift
//  FinSight
//
//  Created by Никита Сторчай on 09.02.2026.
//

import SwiftUI

struct ReportDetailView: View {
    @Environment(SettingsStore.self) private var settings
    
    let report: CustomReport
    
    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading, spacing: 20) {
                heroCard
                overviewCard
                
                if !report.sortedFlaggedCategories.isEmpty {
                    flaggedCategoriesCard
                }
                
                if !report.sortedCategories.isEmpty {
                    categoryBreakdownCard
                }
                
                if !report.sortedTopMerchants.isEmpty {
                    topMerchantsCard
                }
                
                if !report.keyInsights.isEmpty {
                    insightCard
                }
                
                if !report.recommendations.isEmpty {
                    recommendationsCard
                }
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
            .padding(.bottom, 32)
        }
        .background(AppBackground())
        .navigationTitle("Report")
        .navigationBarTitleDisplayMode(.inline)
    }
}

private extension ReportDetailView {
    var heroCard: some View {
        VStack(alignment: .leading, spacing: 18) {
            HStack(alignment: .center, spacing: 12) {
                Text(report.dateRangeText)
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                
                
                Spacer(minLength: 12)
                
                Image(systemName: "chart.line.text.clipboard")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundStyle(.white)
                    .padding(12)
                    .background(Color.white.opacity(0.16))
                    .clipShape(Circle())
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Total spent")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))
                
                Text(report.totalSpent, format: .currency(code: settings.currencyCode))
                    .font(.system(size: 38, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .minimumScaleFactor(0.82)
            }
            .padding(.bottom, 8)
            
            HStack(spacing: 10) {
                if let topCategory = report.topCategory {
                    heroPill(
                        title: topCategory.category.displayName,
                        subtitle: "Top category"
                    )
                }
                
                Spacer()
                
                if let topMerchant = report.topMerchant {
                    heroPill(
                        title: topMerchant.name,
                        subtitle: "Top merchant"
                    )
                }
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
    
    var overviewCard: some View {
        ReportSectionCard(title: "Overview", subtitle: "What defined this reporting window.") {
            Text(report.overview)
                .font(.body)
                .foregroundStyle(.primary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
    }
    
    var flaggedCategoriesCard: some View {
        ReportSectionCard(title: "WATCHLIST", subtitle: "Categories that stood out this week.") {
            VStack(spacing: 14) {
                ForEach(report.sortedFlaggedCategories, id: \.category) { item in
                    categoryAmountRow(
                        category: item.category,
                        amount: item.amount,
                        total: max(report.totalSpent, item.amount),
                        accent: item.category.iconInfo.color
                    )
                }
            }
        }
    }
    
    var categoryBreakdownCard: some View {
        ReportSectionCard(title: "BREAKDOWN", subtitle: "Where the money went overall.") {
            VStack(spacing: 14) {
                ForEach(report.sortedCategories, id: \.category) { item in
                    categoryAmountRow(
                        category: item.category,
                        amount: item.amount,
                        total: max(report.totalSpent, item.amount),
                        accent: item.category.iconInfo.color
                    )
                }
            }
        }
    }
    
    var topMerchantsCard: some View {
        ReportSectionCard(title: "MERCHANTS", subtitle: "Highest-impact places across the week.") {
            VStack(spacing: 14) {
                ForEach(report.sortedTopMerchants, id: \.name) { merchant in
                    merchantRow(name: merchant.name, amount: merchant.amount)
                }
            }
        }
    }
    
    var insightCard: some View {
        ReportSectionCard(title: "KEY INSIGHTS", subtitle: "Patterns worth keeping in mind.") {
            VStack(spacing: 12) {
                ForEach(Array(report.keyInsights.enumerated()), id: \.offset) { index, insight in
                    narrativeRow(
                        index: index + 1,
                        text: insight,
                        symbol: "sparkles",
                        accent: settings.appAccentColor.color
                    )
                }
            }
        }
    }
    
    var recommendationsCard: some View {
        ReportSectionCard(title: "RECOMMENDATIONS", subtitle: "Small adjustments for the next week.") {
            VStack(spacing: 12) {
                ForEach(Array(report.recommendations.enumerated()), id: \.offset) { index, recommendation in
                    narrativeRow(
                        index: index + 1,
                        text: recommendation,
                        symbol: "checkmark.circle.fill",
                        accent: .green
                    )
                }
            }
        }
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
    
    func categoryAmountRow(category: Category, amount: Double, total: Double, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                CategoryIcon(category: category)
                
                VStack(alignment: .leading, spacing: 3) {
                    Text(category.displayName)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.primary)
                    
                    Text(amount, format: .currency(code: settings.currencyCode))
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
                
                Spacer(minLength: 12)
                
                Text(progressText(amount: amount, total: total))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            
            ProgressView(value: total == 0 ? 0 : amount / total)
                .tint(accent)
        }
    }
    
    func merchantRow(name: String, amount: Double) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 12) {
                IconBadge(systemName: "building.2.crop.circle.fill", color: settings.appAccentColor.color)
                
                Text(name)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.primary)
                    .lineLimit(1)
                
                Spacer(minLength: 12)
                
                Text(amount, format: .currency(code: settings.currencyCode))
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.secondary)
            }
            
            ProgressView(
                value: report.totalSpent == 0 ? 0 : amount / report.totalSpent
            )
            .tint(settings.appAccentColor.color)
        }
    }
    
    func narrativeRow(index: Int, text: String, symbol: String, accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                Text("\(index)")
                    .font(.system(size: 11, weight: .bold, design: .rounded))
                    .foregroundStyle(accent)
                
                Text(symbol == "sparkles" ? "INSIGHT" : "RECOMMENDATION")
                    .font(.system(size: 11, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .tracking(0.8)
                
                Spacer(minLength: 0)
            }
            
            HStack(alignment: .top, spacing: 12) {
                Capsule(style: .continuous)
                    .fill(accent.opacity(0.32))
                    .frame(width: 3)
                
                Text(text)
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(.primary)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.primary.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.primary.opacity(0.1), lineWidth: 1)
                )
        )
    }
    
    func progressText(amount: Double, total: Double) -> String {
        guard total > 0 else { return "0%" }
        return "\(Int((amount / total) * 100))%"
    }
}

private struct ReportSectionCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content
    
    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }
    
    var body: some View {
        SectionTitle(text: title)
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(subtitle)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
            
            content
        }
        .padding(18)
        .background(CardBackground(cornerRadius: 24))
    }
}

#Preview {
    ReportDetailView(report: .mock)
        .environment(SettingsStore())
}
