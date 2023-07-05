//
//  Meter_InstallationTests.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import XCTest
@testable import Meter_Installation

final class DeviceDataStoreTests: XCTestCase {

    func testImportingNewDevicesWhenFetchingAll() async {
        //  GIVEN
        let response: [DeviceResponse] = [
            .coldWater(installationDate: .now),
            .warmWater()
        ]
        let client = TestDataClient(response: response)
        let dataStore = DataStorage.test(client: client)

        //  WHEN
        try? await dataStore.fetchDevices()

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 2)

        let firstDevice = storedDevices[0]
        XCTAssertEqual(firstDevice.id, "coldWater")
        XCTAssertEqual(firstDevice.meterPointDescription, "meterPointDescription")
        XCTAssertEqual(firstDevice.type, "cold_water")
        XCTAssertNotNil(firstDevice.installationDate)
        XCTAssertTrue(firstDevice.synced)

        let secondDevice = storedDevices[1]
        XCTAssertEqual(secondDevice.id, "warmWater")
        XCTAssertEqual(secondDevice.meterPointDescription, "meterPointDescription")
        XCTAssertEqual(secondDevice.type, "warm_water")
        XCTAssertNil(secondDevice.installationDate)
        XCTAssertTrue(secondDevice.synced)
    }

    func testUpdateExistingDeviceWhenFetchingAll() async {
        //  GIVEN
        let response: [DeviceResponse] = [
            .coldWater(meterPointDescription: "newDescription", installationDate: .now)
        ]
        let client = TestDataClient(response: response)
        let dataStore = DataStorage.test(client: client)
        let device = dataStore.insertDevice(.coldWater())

        //  WHEN
        try? await dataStore.fetchDevices()

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 1)

        let storedDevice = storedDevices[0]
        XCTAssertEqual(storedDevice.id, "coldWater")
        XCTAssertEqual(storedDevice.meterPointDescription, "newDescription")
        XCTAssertEqual(storedDevice.type, "cold_water")
        XCTAssertNotNil(storedDevice.installationDate)
        XCTAssertTrue(device.synced)
    }

    func testSyncNotChangedWhenUpdatingAnExistingDeviceWithNoInstallDate() async {
        //  GIVEN
        let response: [DeviceResponse] = [
            .coldWater(meterPointDescription: "newDescription", installationDate: nil)
        ]
        let client = TestDataClient(response: response)
        let dataStore = DataStorage.test(client: client)
        let device = dataStore.insertDevice(.coldWater(), synced: false)

        //  WHEN
        try? await dataStore.fetchDevices()

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 1)

        let storedDevice = storedDevices[0]
        XCTAssertEqual(storedDevice.meterPointDescription, "newDescription")
        XCTAssertFalse(device.synced)
    }

    func testSyncChangedWhenUpdatingAnExistingDeviceWithInstallDate() async {
        //  GIVEN
        let response: [DeviceResponse] = [
            .coldWater(meterPointDescription: "newDescription", installationDate: .now)
        ]
        let client = TestDataClient(response: response)
        let dataStore = DataStorage.test(client: client)
        let device = dataStore.insertDevice(.coldWater(installationDate: .now), synced: false)

        //  WHEN
        try? await dataStore.fetchDevices()

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 1)

        let storedDevice = storedDevices[0]
        XCTAssertTrue(device.synced)
    }

    func testIgnoringInvalidDevicesWhenFetchingAll() async {
        //  GIVEN
        let response: [DeviceResponse] = [
            .invalid(),
            .coldWater()
        ]
        let client = TestDataClient(response: response)
        let dataStore = DataStorage.test(client: client)

        //  WHEN
        try? await dataStore.fetchDevices()

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 1)
        XCTAssertEqual(storedDevices.first?.id, "coldWater")
    }

    func testFetchDevicesErrorWhenResponseIsUnexpected() async {
        //  GIVEN
        let client = TestDataClient()
        let dataStore = DataStorage.test(client: client)

        //  WHEN
        var expectedError: Error?
        do {
            try await dataStore.fetchDevices()
        } catch {
            expectedError = error
        }

        //  THEN
        XCTAssertEqual(expectedError as? MeterInstallationError, .fetchDevices)
    }
}
