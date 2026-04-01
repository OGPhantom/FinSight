//
//  SortOrder.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import Foundation

enum SortOrder {
    case descending
    case ascending
    
    var title: String {
        switch self {
        case .descending:
            return "Newest first"
        case .ascending:
            return "Oldest first"
        }
    }
}
