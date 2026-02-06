//
//  CategoryIcon.swift
//  FinSight
//
//  Created by Никита Сторчай on 06.02.2026.
//

import SwiftUI

struct CategoryIcon: View {
    var category: Transaction.Category
    var body: some View {
        let info = category.iconInfo

        Image(systemName: info.symbol)
            .font(.system(size: 14, weight: .semibold))
            .foregroundStyle(.white)
            .frame(width: 32, height: 32)
            .background(Circle().fill(info.color.gradient))
    }
}

#Preview {
    CategoryIcon(category: .dining)
}
