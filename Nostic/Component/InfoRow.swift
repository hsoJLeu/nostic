//
//  InfoRow.swift
//  Nostic
//
//  Created by Josh Leung on 4/22/23.
//

import SwiftUI

struct InfoRow: View {
    var left: String
    var right: String
    
    var body: some View {
        HStack {
            Text(left).frame(alignment: .leading)
            Text(right)
                .padding(EdgeInsets(top: 0, leading: 30, bottom: 0, trailing: 0))
                .lineLimit(1)
        }
    }
}

struct InfoRow_Previews: PreviewProvider {
    static var previews: some View {
        InfoRow(left: "Sensor1", right: "1243")
    }
}
