//
//  ListItemView.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import SwiftUI

struct ListItemView: View {
    let device: Device
    let swipeAction: (_ device: Device) -> Void

    var body: some View {
        HStack(spacing: 8) {
            Image(systemName: device.deviceType.systemImageName)
                .renderingMode(.template)
                .foregroundColor(device.deviceType.imageColor)
            VStack(alignment: .leading) {
                Text(device.identifier)
                    .font(.title3)
                Text(device.meterPointText)
                    .font(.headline)
                    .foregroundColor(.secondary)
            }
            Spacer()
            Image(systemName: device.status.systemImageName)
                .renderingMode(.template)
                .imageScale(.small)
                .foregroundColor(device.status.imageColor)

        }
        .swipeActions {
            Group {
                if isSwipeEnabled {
                    Button(swipeButtonTitle, role: swipeButtonRole) {
                        swipeAction(device)
                    }
                }
            }
        }
    }

    private var isSwipeEnabled: Bool {
        guard device.isInstalled, device.synced else { return true }
        return false
    }

    private var swipeButtonTitle: String {
        device.isInstalled ? "Uninstall" : "Install"
    }

    private var swipeButtonRole: ButtonRole? {
        device.isInstalled ? .destructive : .none
    }
}

struct ListItemView_Previews: PreviewProvider {
    static var previews: some View {
        let device = Device(context: DataProvider.preview.viewContext)
        device.id = "WWM-0001-12"
        device.installationDate = Date()
        device.meterPointDescription = "Kitchen"
        device.type = "warm_water"
        return ListItemView(device: device) { _ in }
    }
}
