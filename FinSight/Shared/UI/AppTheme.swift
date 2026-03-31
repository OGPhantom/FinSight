//
//  AppTheme.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//


enum AppTheme: String, CaseIterable {
    case system
    case light
    case dark
    
    var title: String {
        switch self {
        case .system: return "System"
        case .light: return "Light"
        case .dark: return "Dark"
        }
    }
    
    var icon: String {
        switch self {
        case .system: return "gear"
        case .light: return "sun.max"
        case .dark: return "moon"
        }
    }
}
