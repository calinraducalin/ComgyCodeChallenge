//
//  File.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

protocol DeviceSyncProviding: DataProviding {
    func syncDevices(_ devices: [Device]) async throws
}

extension DataProvider: DeviceSyncProviding {
    func syncDevices(_ devices: [Device]) async throws  {
        try await withThrowingTaskGroup(of: Device.self) { group in
            devices.forEach { device in
                group.addTask {
                    try await self.syncDevice(device)
                    return device
                }
            }
            return try await group.waitForAll()
        }
    }
}

private extension DeviceSyncProviding {
    func syncDevice(_ device: Device) async throws {
        let syncURL = client.makeURL(endpoint: "/devices/\(device.identifier)")
        let encoder = client.makeEncoder()
        do {
            let data = try encoder.encode(device.makePatchInfo())
            try await client.patchData(data, to: syncURL)
        } catch {
            throw MeterInstallationError.wrongDataFormat(error: error)
        }
    }
}

private extension Device {
    func makePatchInfo() -> DevicePatchInfo {
        DevicePatchInfo(id: identifier, installationDate: installationDate ?? Date())
    }
}
