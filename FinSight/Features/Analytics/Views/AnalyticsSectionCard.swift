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
        VStack(alignment: .leading, spacing: 12) {
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
}

#Preview {
    AnalyticsSectionCard(title: "WEEKDAY RHYTHM",
                         subtitle: "How your spending intensity changes across the week.") {
        
    }
}
