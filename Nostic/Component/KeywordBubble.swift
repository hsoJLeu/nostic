//
//  KeywordBubble.swift
//  Nostic
//
//  Created by Josh Leung on 3/2/23.
//

import SwiftUI

struct KeywordBubble: View {
    let keyword: String
    let symbol: String
    let bgColor: Color
    
    var body: some View {
        Label(keyword, systemImage: symbol)
            .font(.title3)
            .foregroundColor(.white)
            .padding()
            .background(bgColor, in: Capsule())
    }
}

struct KeywordBubble_Previews: PreviewProvider {
    static let keywords = ["chives", "fern-leaf lavender"]
    static var previews: some View {
        VStack {
                ForEach(keywords, id: \.self) { word in
                    KeywordBubble(keyword: word, symbol: "leaf", bgColor: .purple.opacity(0.75))
                }
            }
    }
}
