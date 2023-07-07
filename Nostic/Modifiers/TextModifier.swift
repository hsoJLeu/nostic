//
//  TextModifier.swift
//  Nostic
//
//  Created by Josh Leung on 4/21/23.
//

import SwiftUI

struct DefaultGaugeText: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.system(.body, design: .rounded))
            .bold()
            .foregroundColor(.gray) 
    }
}

