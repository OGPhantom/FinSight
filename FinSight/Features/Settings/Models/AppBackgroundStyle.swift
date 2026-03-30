//
//  AppBackgroundStyle.swift
//  FinSight
//
//  Created by Никита Сторчай on 30.03.2026.
//

import SwiftUI

enum AppBackgroundStyle: String, CaseIterable {
    case softGray
    case blueGradient
    case greenGradient
    case darkPremium

    func colors() -> [Color] {
        switch self {
        case .softGray:
            return [
                Color(red: 0.96, green: 0.97, blue: 0.98),
                Color(red: 0.93, green: 0.94, blue: 0.96)
            ]

        case .blueGradient:
            return [Color.blue.opacity(0.6), Color.blue.opacity(0.2)]

        case .greenGradient:
            return [Color.green.opacity(0.6), Color.green.opacity(0.2)]

        case .darkPremium:
            return [Color.black, Color.gray.opacity(0.4)]
        }
    }
}
