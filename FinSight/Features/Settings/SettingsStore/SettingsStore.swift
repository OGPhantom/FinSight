//
//  SettingsStore.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import Foundation
import SwiftUI

@Observable
final class SettingsStore {
    private let defaults = UserDefaults.standard

    private let currencyKey = "selectedCurrency"
    private let themeKey = "selectedTheme"

    private(set) var currency: Currency
    private(set) var appTheme: AppTheme

    init() {
        let currencyRaw = defaults.string(forKey: currencyKey) ?? Currency.usd.rawValue
        self.currency = Currency(rawValue: currencyRaw) ?? .usd

        let themeRaw = defaults.string(forKey: themeKey) ?? AppTheme.system.rawValue
        self.appTheme = AppTheme(rawValue: themeRaw) ?? .system
    }

    func setCurrency(_ newValue: Currency) {
        currency = newValue
        defaults.set(newValue.rawValue, forKey: currencyKey)
    }

    func setTheme(_ newValue: AppTheme) {
        appTheme = newValue
        defaults.set(newValue.rawValue, forKey: themeKey)
    }
}
