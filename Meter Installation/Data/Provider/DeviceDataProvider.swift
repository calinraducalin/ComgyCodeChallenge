//
//  DeviceDataProvider.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import CoreData

protocol DeviceDataProviding: DataProviding {
    func fetchDevices() async throws

}

extension DataProvider: DeviceDataProviding {
    func fetchDevices() async throws {
        let devicesURL = client.makeURL(endpoint: "/devices")
        let data = try await client.getData(from: devicesURL)
        do {
            let decoder = client.makeDecoder()
            let devices = try decoder.decode([DeviceResponse].self, from: data)
            logger.debug("Reveived devices: \(devices.count)")
            try await importDevices(devices)
        } catch {
            throw MeterInstallationError.wrongDataFormat(error: error)
        }
    }
}

private extension DataProvider {
    func importDevices(_ devices: [DeviceResponse]) async throws {
        guard !devices.isEmpty else { return }

        let taskContext = makeNewTaskContext()
        taskContext.name = "importContext"
        taskContext.transactionAuthor = "importDevices"

        let validDevices = devices.filter { $0.isValid }
        validDevices.forEach { remoteDevice in
            let device = Device(context: taskContext)
            device.id = remoteDevice.id
            device.type = remoteDevice.type
            device.meterPointDescription = remoteDevice.meterPointDescription
            device.installationDate = remoteDevice.installationDate
        }

        if validDevices.count != devices.count {
            let invalidDevices = devices.filter { !$0.isValid }
            logger.debug("Ignorred invalid devices: \(invalidDevices)")
            logger.debug("\(invalidDevices.description)")
        }

        taskContext.saveIfNeeded()
    }
}