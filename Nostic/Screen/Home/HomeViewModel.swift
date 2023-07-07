//
//  HomeObserver.swift
//  Nostic
//
//  Created by Josh Leung on 3/9/23.
//

import Foundation
import Combine
import CoreBluetooth

class HomeViewModel: ObservableObject {
    private var obdClient: CBClient = .instance
    private var cancellables: Set<AnyCancellable> = []
    
    @Published var devices: [Device]
    @Published var selectedDevice: Device?
    @Published var connected: Bool = false
    
    /**
     * Main goal of the home view model:
     *  - Connect to a bluetooth source
     *  - Close and display basic values from characteristics
     *  - Id
     */
    init() {
        self.devices = obdClient.peripheralList
        setup()
    }
    
    private func setup() {
        obdClient.$peripheralList
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self]devices in
            self?.devices = devices
            }).store(in: &cancellables)
        
        selectedDevice.publisher.sink { [weak self]  device in
            if device.peripheral.state == .connected {
                self?.connected = true
            } else {
                self?.connected = false
            }
        }.store(in: &cancellables)
    }
    
    func selectPeripheral(identifier: UUID) {
        if let selected = obdClient.peripheralList.first(where: { $0.peripheral.identifier == identifier }) {
            selectedDevice = selected
            //            obdClient.connect(to: selected.peripheral)
            //            selectedDevice = Device(peripheral: selected.peripheral, name: selected.name)
        }
    }
    
    func updateConnectors() {
        devices = obdClient.peripheralList
        selectedDevice = obdClient.currentDevice
    }
    
    func handleConnect() {
        guard let device = selectedDevice else { return }
        
        if connected && obdClient.getCurrentPeripheralState() == .connected {
            obdClient.disconnect()
        } else {
            obdClient.connect(to: device.peripheral)
        }
    }
}
