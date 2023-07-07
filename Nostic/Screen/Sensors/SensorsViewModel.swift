//
//  SensorsObserver.swift
//  Nostic
//
//  Created by Josh Leung on 4/21/23.
//

import SwiftUI
import Combine

class SensorsViewModel: ObservableObject {
    private let obdClient: CBClient

    @Published var serviceList: [Service] = []
    @Published var selectedService: Service?
    @Published var sensorList: [Sensor] = []
    @Published var status: String = ""
    @Published var device: Device?

    private var cancellables: Set<AnyCancellable> = []

    init(obdClient: CBClient = .instance) {
        self.obdClient = obdClient

        obdClient.$currentDevice.sink(receiveValue: { device in
             self.device = device
             if let services = device?.services {
                 print("service map: \(services.description)")
                 self.serviceList = services
                 self.selectedService = services.first
                 self.getCharacteristics(from: services.first?.service.uuid.uuidString ?? "")
             }
         }).store(in: &cancellables)

        self.status = obdClient.getPeripheralState()
    }

    func getCharacteristics(from service: String) {
        sensorList.removeAll()

        if let service = device?.peripheral.services?.filter({ $0.uuid.uuidString == service }).first,
            let chars = service.characteristics {
            for characteristic in chars {
                sensorList.append(Sensor(name: characteristic.description,
                                         characteristic: characteristic,
                                         type: characteristic.properties))
            }
        }
    }

    // NOTE: Only gets characteristics of first service
//    func updateSensorList() {
//        sensorList.removeAll()
//        if let sensors = device?.peripheral.services?.first?.characteristics {
//            for sensor in sensors {
//                sensorList.append(Sensor(name: sensor.uuid.uuidString,
//                                         characteristic: sensor,
//                                         type: sensor.properties))
//            }
//        }
//    }

    func readSensorData() {
        if let services = device?.services {
            for service in services {
                if let characteristics = service.service.characteristics {
                    characteristics.forEach { sensor in
                        if let data = sensor.value {
                            print("Read: \(String(describing: sensor.uuid)): " +
                                  "\(String(data: data, encoding: .utf8))")
                        }
                        
                    }
                }
            }
        }
    }
    
    func updatesServiceList() {
        if let services = obdClient.currentDevice?.services {
            self.serviceList = services
        }
    }

}
