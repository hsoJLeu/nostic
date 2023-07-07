//
//  CustomModifier.swift
//  Nostic
//
//  Created by Josh Leung on 4/18/23.
//

import SwiftUI

struct DefaultButtonModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .buttonStyle(.bordered)
            .fontWeight(.regular)
    }
}

extension View {
    func defaultButton() -> some View {
        modifier(DefaultButtonModifier())
    }
}
