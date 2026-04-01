//
//  AnalyticsTileView.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

struct AnalyticsTileView: View {
    var body: some View {
        ZStack(alignment: .trailing) {
            SettingsTileView(item: SettingsItem.analytics)

            Image(systemName: "chevron.right")
                .font(.system(size: 14, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.trailing, 16)
        }
    }
}

#Preview {
    AnalyticsTileView()
}
