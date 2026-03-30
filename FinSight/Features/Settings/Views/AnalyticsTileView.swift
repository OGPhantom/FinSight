//
//  AnalyticsTileView.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

struct AnalyticsTileView: View {
    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                SettingsTileIcon(item: SettingsItem.analytics)

                Text(SettingsItem.analytics.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(SettingsItem.analytics.subtitle)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.75))
            }

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
        }
        .padding()
        .frame(height: 130)
        .frame(maxWidth: SettingsItem.analytics.isWide ? .infinity : 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(SettingsItem.analytics.bgColor)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    AnalyticsTileView()
}
