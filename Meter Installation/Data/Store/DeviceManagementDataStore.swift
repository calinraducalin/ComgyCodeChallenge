//
//  DeviceManagementDataStore.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

protocol DeviceManagementDataStore: DataStore {
    func updateDevice(_ device: Device, isInstalled: Bool)
    func markAsSyncedDevices(_ devices: [Device])
}

extension DataStorage: DeviceManagementDataStore {
    func updateDevice(_ device: Device, isInstalled: Bool) {
        device.installationDate = isInstalled ? .now : nil
        device.synced = !isInstalled
        device.managedObjectContext?.saveIfNeeded()
    }

    func markAsSyncedDevices(_ devices: [Device]) {
        devices.forEach { $0.synced = true }
        devices.first?.managedObjectContext?.saveIfNeeded()
    }
}
