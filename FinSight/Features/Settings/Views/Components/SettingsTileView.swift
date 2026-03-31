//
//  SettingsTileView.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

struct SettingsTileView: View {
    let item: SettingsItem

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 4) {
                SettingsTileIcon(item: item)

                Text(item.title)
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)

                Text(item.subtitle)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundStyle(.white.opacity(0.75))
            }

            Spacer()
        }
        .padding()
        .frame(height: 130)
        .frame(maxWidth: item.isWide ? .infinity : 200)
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(item.bgColor.gradient)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)
        )
    }
}

#Preview {
    VStack(spacing: 16) {
        HStack(spacing: 16) {
            SettingsTileView(item: .currency)
            SettingsTileView(item: .appearance)
        }

        HStack(spacing: 16) {
            SettingsTileView(item: .categories)
            SettingsTileView(item: .resetData)
        }

        SettingsTileView(item: .analytics)
    }
    .padding()
}
