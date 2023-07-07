//
//  ChartView.swift
//  app
//
//  Created by Josh Leung on 2/2/23.
//
// swiftlint:disable all

import Charts
import SwiftUI

struct ChartView: View {
    var body: some View {
        VStack {
            Chart(BaseShape.make(count: 5)) {
                LineMark(
                    x: .value("X", $0.type),
                    y: .value("Y", $0.value)
                )
            }.frame(height: 200)
                .cornerRadius(10)
            
            Text("info 2")
        }
    }
}

struct ChartView_Previews: PreviewProvider {
    static var previews: some View {
        ChartView()
    }
}

struct BaseShape: Identifiable {
    var type: String
    var value: Double
    var id = UUID()

    static func make(count: Int) -> [BaseShape] {
        var result = [BaseShape]()

        for index in 0...count {
            result.append(BaseShape(type: "\(index)", value: Double(arc4random())))
        }


        return result
    }
}

// swiftlint:enable all
