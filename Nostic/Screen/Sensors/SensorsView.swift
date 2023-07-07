//
//  Gauges.swift
//  Nostic
//
//  Created by Josh Leung on 4/6/23.
//

import SwiftUI

struct SensorsScreen: View {
    @StateObject private var viewModel: SensorsViewModel
    @State var selectedService: Service?

    init() {
        _viewModel = StateObject(wrappedValue: SensorsViewModel())
    }

    var body: some View {
        VStack(spacing: 40) {
            Group {
                Text(Constants.info)
                    .bold()
                    .fontWeight(.medium)
                InfoRow(left: "\(Constants.status):", right: viewModel.status)
                InfoRow(left: "\(Constants.deviceName):", right: viewModel.device?.name ?? Constants.none)
            }

            // Picker determines what sensor info is displayed
            Picker("Service", selection: $selectedService) {
                ForEach(viewModel.serviceList, id: \.id) { service in
                    Button {
                        viewModel.getCharacteristics(from: service.name)
                    } label: {
                        Text(service.name)
                    }

                }
            }.padding()

            if !viewModel.sensorList.isEmpty {
                List(viewModel.sensorList) { sensor in
                    if let value = sensor.characteristic.value {
                        InfoRow(left: "\(Constants.sensorName): \(sensor.name ?? "N/A")",
                                right: "\(String(describing: value.first))")
                    }
                }
            }

            HStack(alignment: .center) {
                Button(Constants.discoverServiceButton) {
                    getSensors()
                }.defaultButton()

                Button(Constants.updateSensorsButton) {
//                    viewModel.updateSensorList()
                }.defaultButton()
            }
        }
    }

    func getSensors() {
        viewModel.updatesServiceList()
        viewModel.readSensorData()
    }

    private struct Constants {
        static let title = "Sensors"
        static let discoverServiceButton = "Discover Services"
        static let updateSensorsButton = "Update Sensors"
        static let status = "Status"
        static let info = "Info"
        static let deviceName = "Device name"
        static let sensorName = "Sensor"
        static let notAvailable = "N/A"
        static let none = "none"
    }
}

struct Gauges_Previews: PreviewProvider {
    static let cbClient = CBClient(mock: true)
    static var previews: some View {
        SensorsScreen()
    }
}
