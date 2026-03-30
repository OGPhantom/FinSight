//
//  CurrencySettingsViewModel.swift
//  FinSight
//
//  Created by Никита Сторчай on 30.03.2026.
//

import Foundation

@Observable
final class CurrencySettingsViewModel {
    var searchQuery: String = ""
    
    private let currencies: [Currency]

    init(currencies: [Currency] = CurrencyService.shared.currencies) {
        self.currencies = currencies
    }

    var filteredCurrencies: [Currency] {
        guard !searchQuery.isEmpty else { return currencies }

        let query = searchQuery.lowercased()

        return currencies.filter {
            $0.name.lowercased().contains(query) ||
            $0.code.lowercased().contains(query) ||
            $0.region.lowercased().contains(query)
        }
    }
}
