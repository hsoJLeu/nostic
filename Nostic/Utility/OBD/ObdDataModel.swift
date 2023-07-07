//
//  ObdDataModel.swift
//  Nostic
//
//  Created by Josh Leung on 4/20/23.
//

import Foundation
import CoreBluetooth

struct Device: Identifiable {
    let id = UUID()
    var peripheral: CBPeripheral
    let name: String
    var services: [Service] = []
}

struct Service: Identifiable, Hashable {
    let id = UUID()
    var service: CBService
    var name: String
    var sensor: [String: Sensor] = [:]
    func hash(into hasher: inout Hasher) {
    }
}

struct Sensor: Equatable, Identifiable {
    let id = UUID()
    let name: String?
    var characteristic: CBCharacteristic
    var descriptors: [CBMutableDescriptor] = []
    let type: CBCharacteristicProperties
}

class OnboardDiagnostic: CBPeripheral {
    
}

extension Device {
    func getCharacteristic(for item: CBCharacteristic?) {
        if let item = item {
            self.peripheral.readValue(for: item)
        }
    }
}
