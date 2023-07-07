//
//  TabBar.swift
//  Nostic
//
//  Created by Josh Leung on 3/1/23.
//

import SwiftUI

struct TabBar<Content: View>: View {
    private var content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        TabView {
            content
        }
    }
    
    enum Tab {
        case home
        case sensors
        case settings
    }
}

struct TabBar_Previews: PreviewProvider {
    
    static var previews: some View {
        TabBar {
            HomeScreen().tabItem {
                Label("Home", systemImage: "house")
            }.font(.title)
            SensorsScreen().tabItem {
                Label("Sensors", systemImage: "sensor")
            }
            ChartView().tabItem {
                Label("Chart", systemImage: "chart.bar")
            }
            Settings().tabItem {
                Label("Settings", systemImage: "person.fill")
            }
        }
    }
}
