//
//  AppBackground.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct AppBackground: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ZStack {
            (scheme == .dark
             ? Color(red: 0.08, green: 0.09, blue: 0.11)
             : Color(red: 0.96, green: 0.97, blue: 0.98))

            RadialGradient(
                colors: [
                    settings.appAccentColor.color.opacity(0.45),
                    .clear
                ],
                center: .top,
                startRadius: 0,
                endRadius: 350
            )
            .blur(radius: 60)
        }
        .ignoresSafeArea()
    }
}
#Preview {
    AppBackground().environment(SettingsStore())
}
