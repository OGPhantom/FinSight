//
//  ContentView.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import SwiftUI

struct ContentView: View {
    @Environment(SettingsStore.self) private var settings

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
        .preferredColorScheme(
            settings.appTheme == .system ? nil :
            settings.appTheme == .dark ? .dark : .light
        )
    }
}

#Preview {
    ContentView()
}
