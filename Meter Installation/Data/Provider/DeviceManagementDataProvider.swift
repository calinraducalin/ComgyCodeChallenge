//
//  DeviceManagementDataProvider.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

protocol DeviceManagementDataProviding: DataProviding {
    func updateDevice(_ device: Device, isInstalled: Bool)
}

extension DataProvider: DeviceManagementDataProviding {
    func updateDevice(_ device: Device, isInstalled: Bool) {
        device.installationDate = isInstalled ? .now : nil
        device.synced = !isInstalled
        device.managedObjectContext?.saveIfNeeded()
    }
}
