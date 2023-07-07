//
//  OBDCommand.swift
//  Nostic
//
//  Created by Josh Leung on 5/24/23.
//

import Foundation
import CombineCoreBluetooth

///  service on top of bluetooth client to connect with obd peripheral
class CentralDevice: ObservableObject {
    @Published var peripherals: [PeripheralDiscovery]?
    private let central: CentralManager = .live()
    
    private var cancellables: Set<AnyCancellable> = []

    func scanAndRetrievePeripheral(serviceIds: [CBUUID]? = nil) {
        central.scanForPeripherals(withServices: serviceIds).scan([]) { list, discovery -> [PeripheralDiscovery] in
            guard !list.contains(where: { $0.id == discovery.id }) else { return list }
            return list + [discovery]
        }
        .receive(on: DispatchQueue.main)
        .sink { self.peripherals = $0 }
        .store(in: &cancellables)
    }

    enum CommandError: Error {
        case unableToWriteValue
    }
}

class PeripheralDevice: ObservableObject {
    private let peripheral: Peripheral
    private var cancellables: Set<AnyCancellable> = []

    @Published var readResponseResult: Result<Data, Error>?
    @Published var writeResponseResult: Result<Date, Error>?
    @Published var services: [CBService]?

    init(peripheral: Peripheral) {
        self.peripheral = peripheral
    }

    func getServices() {
        peripheral.discoverServices(nil).sink {_ in } receiveValue: { services in
            self.services = services
        }

    }

    func command(value: Data,
                 for characteristic: CBCharacteristic,
                 result: ReferenceWritableKeyPath<PeripheralDevice, Published<Result<Date, Error>?>.Publisher>) {
        peripheral.writeValue(value, for: characteristic, type: .withResponse)
            .receive(on: DispatchQueue.main)
            .map { _ in Result<Date, Error>.success(Date()) }
            .catch { err in Just(Result.failure(err)) }
            .assign(to: &self[keyPath: result])
    }

    func read(for characteristic: CBCharacteristic,
              result: ReferenceWritableKeyPath<PeripheralDevice, Published<Result<Data, Error>?>.Publisher>) {
        peripheral.readValue(for: characteristic)
            .receive(on: DispatchQueue.main)
            .map { val in
                guard let val = val else { return nil }
                return Result<Data, Error>.success(val)
            }
            .catch { err in Just(Result.failure(err)) }
            .assign(to: &self[keyPath: result])
    }
}

struct OBD2PIDs {
    // Service ID's
    static let serviceIDs = [CBUUID(string: "E7810A71-73AE-499D-8C15-FAA9AEF0C3F2"),
                             CBUUID(string: "FFF0"),
                             CBUUID(string: "FFE0"),
                             CBUUID(string: "BEEF")]

    // Characteristic ID's
    static let characteristicIDs = [CBUUID(string: ""),
                             CBUUID(string: ""),
                             CBUUID(string: "")]

}
