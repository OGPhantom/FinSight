//
//  ContentView.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }

            ReportsView()
                .tabItem {
                    Label("Reports", systemImage: "chart.bar.xaxis")
                }
        }
    }
}

#Preview {
    ContentView()
}
