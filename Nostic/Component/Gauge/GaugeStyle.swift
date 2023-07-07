//
//  GaugeStyle.swift
//  Nostic
//
//  Created by Josh Leung on 2/28/23.
//

import SwiftUI

struct BaseGaugeStyle: GaugeStyle {
    private var gradient: LinearGradient
    private var gaugeText: Text
    private var width: CGFloat
    private var height: CGFloat
    
    init(gradient: LinearGradient, text: Text, width: CGFloat = 200, height: CGFloat = 200) {
        self.gradient = gradient
        self.gaugeText = text
        self.width = width
        self.height = height
    }
    
    func makeBody(configuration: Configuration) -> some View {
        ZStack {
            Circle()
                .foregroundColor(Color(.systemGray6))

            Circle()
                .trim(from: 0, to: 0.75 * configuration.value)
                .stroke(gradient, lineWidth: Constants.gaugeLabelFontSize)
                .rotationEffect(.degrees(Constants.gaugeRotationEfffect))
 
            Circle()
                .trim(from: 0, to: 0.75)
                .stroke(Color.black, style: StrokeStyle(lineWidth: Constants.gaugeDashLineWidth,
                                                        lineCap: .butt,
                                                        lineJoin: .round,
                                                        dash: [1, 34],
                                                        dashPhase: 0.0))
                .rotationEffect(.degrees(135))
            
            Circle().inset(by: -10)
                .trim(from: 0, to: 0.75).stroke(lineWidth: 1.5)
                .rotationEffect(.degrees(135))
            
            VStack {
                configuration.currentValueLabel
                    .font(.system(size: 80, weight: .bold, design: .rounded))
                    .foregroundColor(.gray)
                gaugeText
            }
        }
        .frame(width: width, height: height)
    }
}

struct GaugeStyle_Previews: PreviewProvider {
    static var previews: some View {
        let text = Text("MPH")
            .font(.system(.body, design: .rounded))
            .bold()
            .foregroundColor(.gray)

        Gauge(value: /*@START_MENU_TOKEN@*/0.5/*@END_MENU_TOKEN@*/, in: /*@START_MENU_TOKEN@*/0...1/*@END_MENU_TOKEN@*/) {}
            .gaugeStyle(BaseGaugeStyle(gradient: Colors.purpleGradient,
                                       text: text,
                                       width: 200,
                                       height: 200))
        
    }
}
