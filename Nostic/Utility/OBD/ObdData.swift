//
//  ObdData.swift
//  Nostic
//
//  Created by Josh Leung on 4/17/23.
//

import Foundation
import SwiftUI

class ObdData: ObservableObject {
    var obdClient: CBClient = .instance
    
    @Published var sensorData: Int32?
    
//    func getSensorData(sensor: OBD2Sensor) -> Int {
//        guard let firstCharacteristic = obdClient.characteristicList?.first else { return 0 }
//        if let sensorData = obdClient.getData(for: firstCharacteristic) as? Int {
//            return sensorData
//        }
//        return 0
//    }
    
    func getCurrentPeripheral() throws -> Device {
        guard let device = obdClient.currentDevice else { throw ObdConnectionError.noDevice }
        return device
    }
}

enum ObdConnectionError: Error {
    case noDevice
}
