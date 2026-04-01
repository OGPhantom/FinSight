//
//  FinSightApp.swift
//  FinSight
//
//  Created by Никита Сторчай on 05.02.2026.
//

import SwiftUI
import SwiftData

@main
struct FinSightApp: App {
    @State private var settings = SettingsStore()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(settings)
        }
        .modelContainer(for: [Transaction.self, CustomReport.self])
    }
}
