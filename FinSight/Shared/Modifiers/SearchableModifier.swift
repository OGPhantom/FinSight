//
//  SearchableModifier.swift
//  FinSight
//
//  Created by Никита Сторчай on 01.04.2026.
//

import SwiftUI


struct SearchableModifier: ViewModifier {
    let isEnabled: Bool
    @Binding var text: String

    func body(content: Content) -> some View {
        if isEnabled {
            content.searchable(
                text: $text,
                placement: .navigationBarDrawer(displayMode: .automatic),
                prompt: "Search expenses"
            )
        } else {
            content
        }
    }
}
