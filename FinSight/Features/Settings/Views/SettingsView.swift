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
                    // First Row
                    TotalSpentTileView(amount: viewModel.totalSpent, currencyCode: settings.currencyCode, selectedPeriod: $viewModel.selectedPeriod)

                    // Second Row
                    HStack(spacing: 16) {
                        NavigationLink(value: SettingsDestination.currency) {
                            SettingsTileView(item: .currency)
                        }

                        NavigationLink(value: SettingsDestination.appearance) {
                            SettingsTileView(item: .appearance)
                        }
                    }

                    // Third Row
                    HStack(spacing: 16) {
                        NavigationLink(value: SettingsDestination.categories) {
                            SettingsTileView(item: .categories)
                        }

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
                            Text("This will permanently delete all transactions, reports, and custom category changes.")
                        }
                    }

                    // Fourth Row
                    NavigationLink(value: SettingsDestination.analytics) {
                        AnalyticsTileView()
                    }
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
                    AppearanceView()

                case .categories:
                    CategoryManagementView()

                case .analytics:
                    AnalyticsView()
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

private extension SettingsView {
    func loadMockTransactions() {
        let transactions = Transaction.mocks

        for transaction in transactions {
            context.insert(transaction)
        }
    }
}
#Preview {
    SettingsView().environment(SettingsStore())
}
