//
//  TotalSpentTileView.swift
//  FinSight
//
//  Created by Никита Сторчай on 29.03.2026.
//

import SwiftUI

struct TotalSpentTileView: View {
    var amount: Double
    var currencyCode: String
    @Binding var selectedPeriod: SpendingPeriod
    
    var body: some View {
        ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 20)
                .fill(.green.gradient)
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 4)

            HStack{
                Text("Total Spent")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.white.opacity(0.8))
                    .padding(.top, 12)
                    .padding(.leading, 16)

                Spacer()

                Menu {
                    Button("Week") { selectedPeriod = .week }
                    Button("Month") { selectedPeriod = .month }
                    Button("Year") { selectedPeriod = .year }
                    Button("All time") { selectedPeriod = .all }
                } label: {
                    Text($selectedPeriod.wrappedValue.title)
                        .font(.caption.weight(.semibold))
                        .foregroundStyle(.white.opacity(0.8))
                        .padding(.top, 12)
                        .padding(.trailing, 16)
                }
            }

            Text(amount, format: .currency(code: currencyCode))
                .font(.system(size: 42, weight: .bold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding(.horizontal, 16)
        }
        .frame(height: 140)
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    TotalSpentTileView(amount: 1000.45, currencyCode: "USD", selectedPeriod: .constant(.week))
}

