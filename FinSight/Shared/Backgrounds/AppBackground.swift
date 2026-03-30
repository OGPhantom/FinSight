//
//  AppBackground.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct AppBackground: View {
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        LinearGradient(
            colors: scheme == .dark
            ? [
                Color(red: 0.08, green: 0.09, blue: 0.11),
                Color(red: 0.12, green: 0.13, blue: 0.16)
            ]
            : [
                Color(red: 0.96, green: 0.97, blue: 0.98),
                Color(red: 0.93, green: 0.94, blue: 0.96)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    AppBackground()
}
