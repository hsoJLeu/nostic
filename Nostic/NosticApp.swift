//
//  NosticApp.swift
//  Nostic
//
//  Created by Josh Leung on 2/9/23.
//

import SwiftUI

@main
struct NosticApp: App {
    var body: some Scene {
        WindowGroup {
            TabBar {
                HomeScreen()
                    .tabItem { Label("Home", systemImage: "house") }
                SensorsScreen()
                    .tabItem { Label("Sensors", systemImage: "sensor") }
                ChartView()
                    .tabItem { Label("Chart", systemImage: "chart") }
                Settings()
                    .tabItem { Label("Settings", systemImage: "person.fill") }
            }
        }
    }
}
