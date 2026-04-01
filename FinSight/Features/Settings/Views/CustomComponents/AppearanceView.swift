//
//  AppearanceView.swift
//  FinSight
//
//  Created by Никита Сторчай on 31.03.2026.
//

import SwiftUI

struct AppearanceView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 32) {
                themeSection
                accentSection
            }
            .padding(.horizontal, 20)
            .padding(.top, 16)
        }
        .background(AppBackground())
        .navigationTitle("Appearance")
    }
}

private extension AppearanceView {
    var themeSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            SectionTitle(text: "Theme")

            HStack(spacing: 6) {
                ForEach(AppTheme.allCases, id: \.self) { theme in
                    themeSegment(theme)
                }
            }
            .padding(4)
            .background(
                RoundedRectangle(cornerRadius: 14)
                    .fill(Color.primary.opacity(0.05))
            )
        }
    }

    func themeSegment(_ theme: AppTheme) -> some View {
        let isSelected = settings.appTheme == theme
        let accent = settings.appAccentColor.color

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                settings.setTheme(theme)
            }
        } label: {
            HStack(spacing: 6) {
                Image(systemName: theme.icon)
                    .font(.system(size: 13, weight: .semibold))

                Text(theme.title)
                    .font(.system(size: 13, weight: .medium))
            }
            .foregroundStyle(isSelected ? .white : .primary)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(
                        isSelected
                        ? accent
                        : Color.clear
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

private extension AppearanceView {
    var accentSection: some View {
        VStack(alignment: .leading, spacing: 12) {

            SectionTitle(text: "Accent color")

            LazyVGrid(
                columns: Array(repeating: GridItem(.flexible(), spacing: 16), count: 4),
                spacing: 16
            ) {
                ForEach(AppAccentColor.allCases, id: \.self) { accent in
                    accentCircle(accent)
                }
            }
        }
    }

    func accentCircle(_ accent: AppAccentColor) -> some View {
        let isSelected = settings.appAccentColor == accent

        return Button {
            withAnimation(.spring(duration: 0.3)) {
                settings.setAccentColor(accent)
            }
        } label: {
            ZStack {

                Circle()
                    .fill(accent.color)

                if isSelected {
                    Circle()
                        .stroke(Color.white, lineWidth: 3)
                        .padding(3)

                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundStyle(.white)
                }
            }
            .frame(width: 44, height: 44)
            .shadow(
                color: isSelected
                ? accent.color.opacity(0.5)
                : .black.opacity(0.1),
                radius: isSelected ? 8 : 4,
                x: 0,
                y: 3
            )
            .scaleEffect(isSelected ? 1.05 : 1)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    AppearanceView()
        .environment(SettingsStore())
}
