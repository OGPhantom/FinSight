//
//  CategorySnapshot.swift
//  FinSight
//
//  Created by OpenAI on 03.04.2026.
//

import Foundation
import SwiftUI
import UIKit

struct CategorySnapshot: Codable, Hashable, Identifiable {
    let id: String
    let name: String
    let colorHex: String
    let iconName: String?

    var color: Color {
        Color(hex: colorHex) ?? .gray
    }

    var resolvedIconName: String {
        iconName ?? "tag.fill"
    }
}

struct CategorySpendSummary: Codable, Hashable, Identifiable {
    let snapshot: CategorySnapshot
    let amount: Double

    var id: String { snapshot.id }
}

extension Color {
    init?(hex: String) {
        let sanitized = hex
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "#", with: "")

        guard sanitized.count == 6 || sanitized.count == 8,
              let value = UInt64(sanitized, radix: 16) else {
            return nil
        }

        let red, green, blue, alpha: UInt64

        if sanitized.count == 8 {
            red = (value & 0xFF000000) >> 24
            green = (value & 0x00FF0000) >> 16
            blue = (value & 0x0000FF00) >> 8
            alpha = value & 0x000000FF
        } else {
            red = (value & 0xFF0000) >> 16
            green = (value & 0x00FF00) >> 8
            blue = value & 0x0000FF
            alpha = 255
        }

        self.init(
            .sRGB,
            red: Double(red) / 255.0,
            green: Double(green) / 255.0,
            blue: Double(blue) / 255.0,
            opacity: Double(alpha) / 255.0
        )
    }

    var hexString: String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        return String(
            format: "#%02X%02X%02X",
            Int(red * 255),
            Int(green * 255),
            Int(blue * 255)
        )
    }
}
