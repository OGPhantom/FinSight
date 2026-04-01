//
//  SectionTitle.swift
//  FinSight
//
//  Created by Никита Сторчай on 01.04.2026.
//

import SwiftUI

struct SectionTitle: View {
    let text: String

    var body: some View {
        Text(text.uppercased())
            .font(.system(size: 12, weight: .semibold))
            .foregroundStyle(.secondary)
            .tracking(0.8)
    }
}
