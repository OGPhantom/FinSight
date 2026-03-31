//
//  CategoryIcon.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct CategoryIcon: View {
    var category: Category
    var body: some View {
        let info = category.iconInfo
        
        IconBadge(
            systemName: info.symbol,
            color: info.color
        )
    }
}

#Preview {
    CategoryIcon(category: .dining)
}
