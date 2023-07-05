//
//  DataStorage+Test.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import Foundation
import CoreData
@testable import Meter_Installation

extension DataStorage {

    @discardableResult
    func insertDevice(_ response: DeviceResponse, synced: Bool = true) -> Device {
        let device = Device(context: viewContext)
        device.id = response.id
        device.type = response.type
        device.meterPointDescription = response.meterPointDescription
        device.installationDate = response.installationDate
        device.synced = synced
        device.managedObjectContext?.saveIfNeeded()
        return device
    }

    func getStoredDevices() -> [Device] {
        let sortDescriptor = NSSortDescriptor(keyPath: \Device.id, ascending: true)
        let allDevices: [Device] = viewContext.findAll(sortDescriptors: [sortDescriptor])
        return allDevices
    }

}
