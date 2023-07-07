//
//  BaseViewContainer.swift
//  app
//
//  Created by Josh Leung on 1/31/23.
//

import SwiftUI
 
struct GaugeView: View {
    var title: String
    var lowBound: Double
    var upBound: Double
    var value: Double
    
    let gaugeFont = Font.custom("Comic sans", size: 25).weight(.regular)
    let gradient = [Color(red: 76/255, green: 175/255, blue: 80/255),
                    Color(red: 233/255, green: 30/255, blue: 99/255)]
    
    var body: some View {
        VStack {
            Gauge(value: self.value, in: lowBound...upBound) {}
                .gaugeStyle(BaseGaugeStyle(gradient: LinearGradient(colors: gradient,
                                                                    startPoint: .trailing,
                                                                    endPoint: .leading),
                                           text: Text(value.description).font(gaugeFont),
                width: 200, height: 200))
            Text(title)
                .font(.system(size: 20, weight: .regular, design: .rounded))
        }
    }
}

struct BaseViewContainer_Previews: PreviewProvider {
    static var previews: some View {
        GaugeView(title: "boost(PSI)", lowBound: 0, upBound: 5, value: 3)
        
    }
}
