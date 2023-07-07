//  OBDClient.swift
//
//  Created by Josh Leung on 2/2/23.
//
import CoreBluetooth
import UIKit

class CBClient: NSObject, ObservableObject {
    static let instance = CBClient()

    private var centralManager: CBCentralManager!

    init(mock: Bool = false) {
        super.init()
        if mock {
            // mock init central manager and return mock data
        } else {
            self.centralManager = CBCentralManager(delegate: self, queue: nil)
        }
    }

    private var currentPeripheral: CBPeripheral?
    private var knownPeripherals: [UUID]? {
        get {
            UserDefaults().object(forKey: "peripherals") as? [UUID]
        } set {
            UserDefaults().set(newValue, forKey: "peripherals")
        }
    }

    @Published var currentValuesPublisher: [String]?

    @Published var currentDevice: Device?
    @Published private(set) var peripheralList: [Device] = []

    //    private var sensorDataSubject = PassthroughSubject<Data, Never>()
    //    var sensorDataPublisher: AnyPublisher<Data, Never> {
    //        return sensorDataSubject.eraseToAnyPublisher()
    //    }

    deinit {
        if let peripheral = currentPeripheral {
            self.centralManager.cancelPeripheralConnection(peripheral)
        }
    }

    var centralManagerState: CBManagerState {
        self.centralManager.state
    }

    func getCurrentPeripheralState() -> CBPeripheralState {
        guard let peripheral = currentPeripheral else {
            return CBPeripheralState.disconnected
        }
        return peripheral.state

    }

    func startScan() {
        self.centralManager.scanForPeripherals(withServices: nil)
    }

    func stopScan() {
        self.centralManager.stopScan()
    }

    // NOTE: Must be called after peripheral discovered from scanning
    func connect(to peripheral: CBPeripheral) {
        guard currentPeripheral?.state != .connected else { return }
        self.centralManager.connect(peripheral)
    }

    func disconnect() {
        if let currentPeripheral = currentPeripheral {
            self.centralManager.cancelPeripheralConnection(currentPeripheral)
            print("✅ DISCONNECTED")
        }
    }

    func getAllPeripherals() {
        centralManager.retrieveConnectedPeripherals(withServices: [CBUUID()])
    }

    func getPeripheralState() -> String {
        guard let currentPeripheral = currentPeripheral else { return "Cannot get peripheral state from nil"}

        switch currentPeripheral.state {
        case .connected:
            return "connected"
        case .disconnected:
            return "disconnected"
        case .connecting:
            return "connecting"
        case .disconnecting:
            return "disconnecting"
        default:
            return "unavailable state"
        }
    }

    func discoverServices(with uuid: [CBUUID]? = nil) {
        currentPeripheral?.discoverServices(uuid)
    }

    func getCharacteristics(from service: CBService) -> [CBCharacteristic]? {
        guard self.currentPeripheral?.state == .connected else {
            return nil
        }
        currentPeripheral?.discoverCharacteristics(nil, for: service)

        return service.characteristics
    }

    func getData(for characteristic: CBCharacteristic) -> Data? {
        characteristic.value
    }
}

extension CBClient: CBCentralManagerDelegate, CBPeripheralDelegate {
    // MARK: Central Peripheral Delegate
    internal func peripheral(_ peripheral: CBPeripheral,
                             didDiscoverServices error: Error?) {
        guard error == nil else {
            print("❌ FAILED to discover services with error: \(String(describing: error?.localizedDescription))")
            return
        }

        let message = "✅ didDiscoverService for \(String(describing: peripheral.name)): " +
                      "\(String(describing: peripheral.services?.description))"
        print(message)

        updateServices(peripheral: peripheral)
    }

    private func updateServices(peripheral: CBPeripheral) {
        if let services = peripheral.services {
            for service in services {
                let serviceUUID = service.uuid.uuidString
                if currentDevice?.services.contains(where: { $0.service.uuid != service.uuid }) != nil {
                    self.currentDevice?.services.append(Service(service: service, name: serviceUUID))
                }

                print("Current device services: \(String(describing: service.uuid))")
                _ = getCharacteristics(from: service)
            }
        }
    }

    internal func peripheral(_ peripheral: CBPeripheral,
                             didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        guard let characteristics = service.characteristics else { return }
        if error != nil {
            print("Error: \(String(describing: error?.localizedDescription))")
        }

        // insert into characteristic queue for processing later
        for characteristic in characteristics {
            switch characteristic.properties {
            case .read:
                print("\(characteristic.uuid): properties contains .read")
                peripheral.readValue(for: characteristic)
            case .notify:
                print("\(characteristic.uuid): properties contains .notify")
                peripheral.setNotifyValue(true, for: characteristic)
            case .write:
                print("\(characteristic.uuid): properties contains .write")
            default:
                print("\(characteristic.uuid): properties contains \(characteristic.properties.rawValue)")
            }
            currentPeripheral?.discoverDescriptors(for: characteristic)
        }
    }

    /*  Source of truth
     *  NOTE: update struct to capture new peripheral instance each time?
     */
    internal func peripheral(_ peripheral: CBPeripheral,
                             didUpdateValueFor characteristic: CBCharacteristic, error: Error?) {
        // TODO: Find modular way to read characteristic
        guard error == nil else {
            print("Error: \(String(describing: error?.localizedDescription))")
            return
        }

        // NOTE: Used to capture every value and log
        logValue(characteristic)
    }

    func logValue(_ characteristic: CBCharacteristic) {
        if let data = characteristic.value,
           let currentValueAsString = String(data: data, encoding: .utf8) {
            print("🔺\(characteristic.description)\nSensor value: \(String(describing: currentValueAsString ))")
            currentValuesPublisher?.append(currentValueAsString)
        }
    }

    internal func peripheral(_ peripheral: CBPeripheral,
                             didDiscoverDescriptorsFor characteristic: CBCharacteristic, error: Error?) {
        guard error == nil else {
            print("Failed to discover descriptors: \(String(describing: error?.localizedDescription))")
            return }
        if let descriptors = characteristic.descriptors {
            descriptors.forEach { descriptor in
                print("Descriptor: \(String(describing: descriptor.description))")
            }
        }
    }

    // MARK: Central Manager Delegate
    // Handle discovered peripheral
    internal func centralManager(_ central: CBCentralManager,
                                 didDiscover peripheral: CBPeripheral,
                                 advertisementData: [String: Any],
                                 rssi RSSI: NSNumber) {
        guard peripheral.name != nil,
              !peripheralList.contains(where: { $0.peripheral == peripheral }) else { return }

        print("Discovered: \(peripheral.name ?? "none"),\n" +
              "Description \(peripheral.description)\n " +
              "RSSI val: \(RSSI.intValue)")

        peripheralList.append(Device(peripheral: peripheral,
                                     name: peripheral.name ?? "none"))
    }

    internal func centralManager(_ central: CBCentralManager,
                                 didConnect peripheral: CBPeripheral) {
        print("✅ Connected to peripheral \(peripheral.identifier)")

        self.currentPeripheral = peripheral
        self.currentPeripheral?.delegate = self
        self.currentDevice = Device(peripheral: peripheral, name: peripheral.name ?? "none")

        knownPeripherals?.append(peripheral.identifier)
        stopScan()

        discoverServices()
//        discoverServices(with: OBD2PIDs.serviceIDs)
    }
    
    internal func centralManager(_ central: CBCentralManager,
                                 didFailToConnect peripheral: CBPeripheral,
                                 error: Error?) {
        print("❌ FAILED to connect to \(peripheral.identifier) with error: \(String(describing: error?.localizedDescription))")
    }
    
    internal func centralManagerDidUpdateState(_ central: CBCentralManager) {
        switch central.state {
        case .poweredOn:
            startScan()
            print("❗️Central Manager State: Powered On")
        case .unknown:
            print("❗️Central Manager State: Unknown")
        case .resetting:
            print("❗️Central Manager State: Resetting")
        case .unsupported:
            print("❗️Central Manager State: Unsupported")
        case .unauthorized:
            print("❗️Central Manager State: Unauthorized")
        case .poweredOff:
            print("❗️Central Manager State: Powered Off")
        @unknown default:
            central.stopScan()
        }
    }
}
