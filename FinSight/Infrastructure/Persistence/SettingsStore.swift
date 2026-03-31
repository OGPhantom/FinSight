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
    private let backgroundStyleKey = "selectedBackgroundStyle"
    private let accentColorKey = "selectedAccentColor"

    private(set) var currencyCode: String
    private(set) var appTheme: AppTheme
    private(set) var appAccentColor: AppAccentColor

    init() {
        let currencyRaw = defaults.string(forKey: currencyKey) ?? "USD"
        self.currencyCode = currencyRaw

        let themeRaw = defaults.string(forKey: themeKey) ?? AppTheme.system.rawValue
        self.appTheme = AppTheme(rawValue: themeRaw) ?? .system

        let accentColorRaw = defaults.string(forKey: accentColorKey) ?? AppAccentColor.mintTeal.rawValue
        self.appAccentColor = AppAccentColor(rawValue: accentColorRaw) ?? .mintTeal
    }

    func setCurrency(_ newValue: String) {
        currencyCode = newValue
        defaults.set(newValue, forKey: currencyKey)
    }

    func setTheme(_ newValue: AppTheme) {
        appTheme = newValue
        defaults.set(newValue.rawValue, forKey: themeKey)
    }

    func setAccentColor(_ newValue: AppAccentColor) {
        appAccentColor = newValue
        defaults.set(newValue.rawValue, forKey: accentColorKey)
    }
}
