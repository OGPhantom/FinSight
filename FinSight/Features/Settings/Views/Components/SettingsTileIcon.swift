//
//  SettingsTileIcon.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

struct SettingsTileIcon: View {
    let item: SettingsItem
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 14)
                .fill(.white.opacity(0.8))
                .overlay(
                    RoundedRectangle(cornerRadius: 14)
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
            
            IconBadge(
                systemName: item.icon,
                color: item.iconColor
            )
        }
        .frame(width: 44, height: 44)
    }
}

#Preview {
    SettingsTileIcon(item: .analytics)
}
