//
//  Currency.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import Foundation

struct Currency: Identifiable, Codable, Hashable {
    let code: String
    let name: String
    let region: String
    let flag: String

    var id: String { code }
}
