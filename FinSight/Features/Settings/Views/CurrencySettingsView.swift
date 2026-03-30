//
//  CurrencySettingsView.swift
//  FinSight
//
//  Created by Никита Сторчай on 30.03.2026.
//

import SwiftUI

struct CurrencySettingsView: View {
    @Environment(SettingsStore.self) private var settings
    @State private var viewModel = CurrencySettingsViewModel()
    @Environment(\.colorScheme) private var scheme

    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                section(
                    title: "Most used",
                    currencies: CurrencyService.shared.mostUsed
                )

                section(
                    title: "All currencies",
                    currencies: viewModel.filteredCurrencies
                )
            }
            .padding()
            .searchable(text: $viewModel.searchQuery,  placement: .navigationBarDrawer(displayMode: .automatic), prompt: "Search")
        }
        .background(AppBackground())
        .navigationTitle("Currency")
    }
}

private extension CurrencySettingsView {
    func section(title: String, currencies: [Currency]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.headline)

            VStack(spacing: 0) {
                ForEach(currencies) { currency in
                    currencyRow(currency)

                    if currency != currencies.last {
                        Divider()
                            .padding(.leading, 44)
                            .opacity(0.3)
                    }
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        scheme == .light
                        ? AnyShapeStyle(Color.white)
                        : AnyShapeStyle(.ultraThinMaterial)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(Color.black.opacity(0.06), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.08), radius: 12, x: 0, y: 6)
            .clipShape(RoundedRectangle(cornerRadius: 20))
        }
    }

    func currencyRow(_ currency: Currency) -> some View {
        let isSelected = settings.currencyCode == currency.code

        return Button {
            withAnimation(.spring(duration: 0.3)) {
                settings.setCurrency(currency.code)
            }
        } label: {
            HStack(spacing: 12) {

                Text(currency.flag)
                    .font(.system(size: 24))

                VStack(alignment: .leading, spacing: 4) {
                    Text(currency.name)
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundStyle(.primary)

                    Text(currency.region)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }

                Spacer()

                Text(currency.code)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(.secondary)

                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.green)
                        .transition(.scale)
                }
            }
            .contentShape(Rectangle())
            .padding()
            .background(
                Rectangle()
                    .fill(
                        isSelected
                        ? LinearGradient(
                            colors: [
                                Color.green.opacity(0.25),
                                Color.green.opacity(0.12)
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                        : LinearGradient(
                            colors: [
                                Color.clear,
                                Color.clear
                            ],
                            startPoint: .leading,
                            endPoint: .trailing
                        )
                    )
            )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CurrencySettingsView()
        .environment(SettingsStore())
}
