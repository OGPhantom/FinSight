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
        LinearGradient(colors:
            scheme == .dark
            ?
            [Color.black, Color(.secondarySystemBackground)]
            :
            [Color(.systemGroupedBackground), Color(.secondarySystemGroupedBackground)],

            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()
    }
}

#Preview {
    AppBackground()
}
