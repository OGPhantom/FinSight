//
//  CurrencyService.swift
//  FinSight
//
//  Created by Никита Сторчай on 30.03.2026.
//

import Foundation

final class CurrencyService {
    static let shared = CurrencyService()

    private(set) var currencies: [Currency] = []

    private init() {
        load()
    }

    private func load() {
        guard let url = Bundle.main.url(forResource: "currencies", withExtension: "json"),
              let data = try? Data(contentsOf: url),
              let decoded = try? JSONDecoder().decode([Currency].self, from: data)
        else {
            currencies = []
            return
        }

        currencies = decoded.sorted { $0.name < $1.name }
    }
}

extension CurrencyService {
    var mostUsed: [Currency] {
        currencies.filter {
            ["USD", "EUR", "UAH"].contains($0.code)
        }
    }
}
