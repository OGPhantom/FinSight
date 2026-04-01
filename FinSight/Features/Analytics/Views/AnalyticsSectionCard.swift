//
//  AnalyticsSectionCard.swift
//  FinSight
//
//  Created by Никита Сторчай on 01.04.2026.
//

import SwiftUI

struct AnalyticsSectionCard<Content: View>: View {
    let title: String
    let subtitle: String
    let content: Content

    init(title: String, subtitle: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.subtitle = subtitle
        self.content = content()
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(.secondary)
                    .tracking(0.8)

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
    AnalyticsSectionCard(title: "WEEKDAY RHYTHM",
                         subtitle: "How your spending intensity changes across the week.") {
        
    }
}
