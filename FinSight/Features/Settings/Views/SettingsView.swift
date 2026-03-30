//
//  SettingsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(SettingsStore.self) private var settings
    @State private var viewModel = SettingsViewModel()
    @Query private var transactions: [Transaction]

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 16) {
                    TotalSpentTileView(amount: viewModel.totalSpent, currencyCode: settings.currency.rawValue, selectedPeriod: $viewModel.selectedPeriod)

                    HStack(spacing: 16) {
                        SettingsTile(item: .currency)
                        SettingsTile(item: .appearance)
                    }

                    HStack(spacing: 16) {
                        SettingsTile(item: .categories)
                        SettingsTile(item: .resetData)
                    }

                    AnalyticsTileView()
                }
            }
            .padding()
            .background(AppBackground())
            .navigationTitle("Settings")
        }
        .onAppear {
            viewModel.updateTotal(from: transactions)
        }
        .onChange(of: transactions) {
            viewModel.updateTotal(from: transactions)
        }
        .onChange(of: viewModel.selectedPeriod) {
            viewModel.updateTotal(from: transactions)
        }
    }
}

private extension SettingsView {
    var currencySection: some View {
        Section("Currency") {
            Picker("Currency", selection: Binding (
                get: { settings.currency },
                set: { settings.setCurrency($0) }
            ))
            {
                Text("USD").tag(Currency.usd)
                Text("EUR").tag(Currency.eur)
                Text("UAH").tag(Currency.uah)
            }
            .pickerStyle(.menu)
        }
    }

    var appearanceSection: some View {
        Section("Appearance") {
            Picker("Theme", selection: Binding(
                get: { settings.appTheme },
                set: { settings.setTheme($0)}
            )) {
                Text("System").tag(AppTheme.system)
                Text("Light").tag(AppTheme.light)
                Text("Dark").tag(AppTheme.dark)
            }
            .pickerStyle(.segmented)
        }
    }
}

#Preview {
    SettingsView().environment(SettingsStore())
}
