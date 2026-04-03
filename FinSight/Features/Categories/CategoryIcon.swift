//
//  CategoryIcon.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct CategoryIcon: View {
    let systemName: String
    let color: Color
    var size: CGFloat = 32

    init(systemName: String, color: Color, size: CGFloat = 32) {
        self.systemName = systemName
        self.color = color
        self.size = size
    }

    init(category: TransactionCategory, size: CGFloat = 32) {
        self.init(
            systemName: category.snapshot.resolvedIconName,
            color: category.color,
            size: size
        )
    }

    init(snapshot: CategorySnapshot, size: CGFloat = 32) {
        self.init(
            systemName: snapshot.resolvedIconName,
            color: snapshot.color,
            size: size
        )
    }

    init(legacyCategory: Category, size: CGFloat = 32) {
        self.init(
            systemName: legacyCategory.defaultIconName,
            color: legacyCategory.iconInfo.color,
            size: size
        )
    }

    var body: some View {
        IconBadge(
            systemName: systemName,
            color: color,
            size: size
        )
    }
}

#Preview {
    CategoryIcon(legacyCategory: .dining)
}
