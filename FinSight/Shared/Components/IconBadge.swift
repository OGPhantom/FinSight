//
//  IconBadge.swift
//  FinSight
//
//  Created by Никита Сторчай on 31.03.2026.
//

import SwiftUI

struct IconBadge: View {
    let systemName: String
    let color: Color
    var size: CGFloat = 32

    var body: some View {
        Image(systemName: systemName)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: size, height: size)
            .background(
                Circle()
                    .fill(color.gradient)
            )
    }
}

#Preview{
    IconBadge(systemName: SettingsItem.currency.icon, color: SettingsItem.currency.iconColor)
}
