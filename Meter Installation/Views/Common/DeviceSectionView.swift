//
//  DeviceSectionView.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import SwiftUI

struct DeviceSectionView: View {
    @State private var selectedDevice: Device?
    let title: String
    let devices: [Device]
    let primaryAction: (_ device: Device) -> Void

    var body: some View {
        Group {
            if !devices.isEmpty {
                Section("\(title) (\(devices.count))") {
                    ForEach(devices, id: \.self) { device in
                        Button {
                            selectedDevice = device
                        } label: {
                            ListItemView(device: device) {
                                primaryAction($0)
                            }
                        }
                    }
                }
            }
        }
        .sheet(item: $selectedDevice) { device in
            let viewModel = DeviceDetailsViewModel(device: device) {
                primaryAction(device)
            }
            DeviceDetailsView(viewModel: viewModel)
        }
    }
}

struct DeviceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let device0 = Device(context: DataStorage.test.viewContext)
        device0.id = "WWM-0001-12"
        device0.installationDate = Date()
        device0.meterPointDescription = "Kitchen"
        device0.type = "warm_water"

        let device1 = Device(context: DataStorage.test.viewContext)
        device1.id = "WWM-0001-13"
        device1.installationDate = Date()
        device1.meterPointDescription = "Hallway"
        device1.type = "cold_water"

        return DeviceSectionView(title: "Installed devices", devices: [device0, device1]) { _ in }

    }
}
