//
//  DeviceSectionView.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import SwiftUI


struct DeviceSectionView: View {
    let title: String
    let devices: [Device]

    var body: some View {
        Group {
            if !devices.isEmpty {
                Section("\(title) (\(devices.count))") {
                    ForEach(devices, content: ListItemView.init)
                }
            }
        }
    }
}

struct DeviceSectionView_Previews: PreviewProvider {
    static var previews: some View {
        let device0 = Device(context: DataProvider.preview.viewContext)
        device0.id = "WWM-0001-12"
        device0.installationDate = Date()
        device0.meterPointDescription = "Kitchen"
        device0.type = "warm_water"

        let device1 = Device(context: DataProvider.preview.viewContext)
        device1.id = "WWM-0001-13"
        device1.installationDate = Date()
        device1.meterPointDescription = "Hallway"
        device1.type = "cold_water"

        return DeviceSectionView(title: "Installed devices", devices: [device0, device1])

    }
}
