//
//  SettingsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI
import SwiftData

struct SettingsView: View {
    @Environment(\.modelContext) private var context
    @State private var showAlert = false

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
                            SettingsTileView(item: .currency)
                        }

                        NavigationLink(value: SettingsDestination.appearance) {
                            SettingsTileView(item: .appearance)
                        }
                    }

                    HStack(spacing: 16) {
                        SettingsTileView(item: .categories)

                        Button(role: .destructive) {
                            showAlert = true
                        } label: {
                            SettingsTileView(item: .resetData)
                        }
                        .alert("Reset all data?", isPresented: $showAlert) {
                            Button("Delete", role: .destructive) {
                                DataService.shared.resetAllData(context: context)
                            }
                            Button("Cancel", role: .cancel) {}
                        } message: {
                            Text("This will permanently delete all transactions and reports.")
                        }
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
                    CurrencyView()

                case .appearance:
                    AppearanceSettingsView()

                case .categories:
                    CurrencyView()

                case .analytics:
                    CurrencyView()
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
