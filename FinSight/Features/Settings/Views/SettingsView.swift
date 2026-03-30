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
                    TotalSpentTileView(amount: viewModel.totalSpent, currencyCode: settings.currencyCode, selectedPeriod: $viewModel.selectedPeriod)

                    HStack(spacing: 16) {
                        NavigationLink(value: SettingsDestination.currency) {
                            SettingsTile(item: .currency)
                        }

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
            .navigationDestination(for: SettingsDestination.self) { destination in
                switch destination {
                case .currency:
                    CurrencySettingsView()

                case .appearance:
                    CurrencySettingsView()
                    
                case .categories:
                    CurrencySettingsView()

                case .analytics:
                    CurrencySettingsView()
                }
            }
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

#Preview {
    SettingsView().environment(SettingsStore())
}
