//
//  Settings.swift
//  Nostic
//
//  Created by Josh Leung on 3/2/23.
//

import SwiftUI

struct Settings: View {
    @StateObject private var viewModel = ViewModel()

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.menuItems) { section in
                    Section(section.section) {
                        ForEach(section.items, id: \.self) { item in
                            NavigationLink {

                            } label: {
                                Text(item)
                            }
                        }
                    }
                }
            }
        }
    }
}

struct Settings_Previews: PreviewProvider {
    static var previews: some View {
        Settings()
    }
}

extension Settings {
    class ViewModel: ObservableObject {
        var menuItems: [TextGroup] {
            TextGroup.make()
        }
    }
}

struct TextGroup: Codable, Identifiable {
    var id: UUID = UUID()
    var section: String
    var items: [String]

    static func make() -> [TextGroup] {
        let headers: [String] = ["CONNECTION", "SENSOR VALUES", "DISPLAY PROPERTIES"]
        let items: [String] = ["Adapter", "Automatic connect", "Clear cache"]
        var result: [TextGroup] = []

        for header in headers {
            result.append(TextGroup(section: header, items: items))
        }

        return result
    }
}
