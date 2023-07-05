//
//  DeviceManagementDataStoreTests.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import XCTest
@testable import Meter_Installation

final class DeviceManagementDataStoreTests: XCTestCase {

    override func tearDown() async throws {
        try DataStorage.test.resetAllData()
    }

    func testMarkDeviceAsInstalled() {
        //  GIVEN
        let client = TestDataClient()
        let dataStore = DataStorage.test(client: client)
        let device = dataStore.insertDevice(.coldWater(installationDate: nil), synced: true)

        //  WHEN
        dataStore.updateDevice(device, isInstalled: true)

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 1)
        XCTAssert(storedDevices.first?.synced == false)
        XCTAssertNotNil(storedDevices.first?.installationDate)
    }

    func testUnmarkDeviceAsInstalled() {
        //  GIVEN
        let client = TestDataClient()
        let dataStore = DataStorage.test(client: client)
        let device = dataStore.insertDevice(.heating(installationDate: .now), synced: false)

        //  WHEN
        dataStore.updateDevice(device, isInstalled: false)

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 1)
        XCTAssert(storedDevices.first?.synced == true)
        XCTAssertNil(storedDevices.first?.installationDate)
    }
}
