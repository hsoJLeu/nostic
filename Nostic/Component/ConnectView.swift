//
//  PopoverConnectView.swift
//  Nostic
//
//  Created by Josh Leung on 6/22/23.
//

import SwiftUI
import CombineCoreBluetooth

struct PopoverConnectView: View {
    // Input: Takes in some list of items
    // Output: outputs a connected item
    let items: [Peripheral]
    @EnvironmentObject var viewModel: HomeViewModel

    var body: some View {
        List(items) { item in
            Button(item.name!) {
                viewModel.selectPeripheral(identifier: item.identifier)
            }
        }

        HStack {
            Button {
                viewModel.handleConnect()
            } label: {
                Text(viewModel.connected ? "DISCONNECT" : "CONNECT")
            }
            .frame(minWidth: 0, maxWidth: .infinity)
            .padding()
            .foregroundColor(.white)
            .background(.indigo)
            .cornerRadius(40)

            Button(action: {
                viewModel.updateConnectors()
            }) {
                Image(systemName: "arrow.clockwise")
            }
            .buttonStyle(.bordered)
            .foregroundColor(.indigo)
        }
    }
}
//
//struct PopoverConnectView_Previews: PreviewProvider {
//    static var previews: some View {
////        PopoverConnectView(items: <#T##[Peripheral]#>)
//    }
//}
