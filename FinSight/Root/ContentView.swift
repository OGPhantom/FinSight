//
//  ContentView.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(SettingsStore.self) private var settings
    @Environment(\.modelContext) private var modelContext

    @State private var didPrepareCategories = false

    var body: some View {
        TabView {
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }

            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.bar.xaxis")
                }

            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear.circle")
                }
        }
        .tint(settings.appAccentColor.color)
        .preferredColorScheme(
            settings.appTheme == .system ? nil :
            settings.appTheme == .dark ? .dark : .light
        )
        .task {
            guard !didPrepareCategories else { return }
            didPrepareCategories = true

            do {
                try CategoryMigrationService.prepare(using: modelContext)
            } catch {
                print("Failed to prepare categories: \(error)")
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(SettingsStore())
}
