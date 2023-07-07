//
//  Home.swift
//  Nostic
//
//  Created by Josh Leung on 3/2/23.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject private var viewModel: HomeViewModel = HomeViewModel()
    @State var shouldPopOver: Bool = true
    @StateObject private var central = CentralDevice()


    @State var open = false
    @State var popoverSize = CGSize(width: 300, height: 100)

    var body: some View {
        NavigationStack {
            VStack(spacing: 40) {
                Gauge(value: 0.5){ }
                    .gaugeStyle(BaseGaugeStyle(gradient: Colors.purpleGradient,
                                               text: Text("info"),
                                               width: 300,
                                               height: 300))

                WithPopover(showPopover: $shouldPopOver) {
                    Button(action: { self.shouldPopOver.toggle() }) { Text("Client list").padding() }
                } popoverContent: {
                    VStack {
                        List(viewModel.devices) { device in
                            Button(device.name) {
                                viewModel.selectPeripheral(identifier: device.peripheral.identifier)
                            }
                        }.frame(height: 200)

                        Button(action: { self.viewModel.handleConnect() }) { Text(viewModel.connected ? "DISCONNECT" : "CONNECT") }
                            .frame(minWidth: 0, maxWidth: .infinity)
                            .padding()
                            .foregroundColor(.white)
                            .background(.indigo)
                            .cornerRadius(40)
                        Button {
                            self.shouldPopOver = false
                        } label: {
                            Text("CLOSE")
                        }
                    }
                }
            }
        }
    }
}

struct Home_Previews: PreviewProvider {
    static let cbClient = CBClient()
    
    static var previews: some View {
        TabBar {
            HomeScreen().tabItem {
                Text("Home")
            }
        }
    }
}


