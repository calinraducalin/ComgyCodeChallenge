//
//  DeviceSyncDataStoreTests.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import XCTest
@testable import Meter_Installation

final class DeviceSyncDataStoreTests: XCTestCase {
    
    override func tearDown() async throws {
        try DataStorage.test.resetAllData()
    }

    func testDevicesMarkedAsSyncedWhenSyncSucceeds() async {
        //  GIVEN
        let client = TestDataClient()
        let dataStore = DataStorage.test(client: client)
        let firstDevice = dataStore.insertDevice(.coldWater(installationDate: .now), synced: false)
        let secondDevice = dataStore.insertDevice(.warmWater(installationDate: .now), synced: false)

        //  WHEN
        try? await dataStore.syncDevices([firstDevice, secondDevice])

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 2)
        XCTAssertTrue(storedDevices[0].synced)
        XCTAssertTrue(storedDevices[1].synced)
    }

    func testDevicesNotMarkedAsSyncedWhenSyncFailed() async {
        //  GIVEN
        let client = TestDataClient(error: MeterInstallationError.network)
        let dataStore = DataStorage.test(client: client)
        let firstDevice = dataStore.insertDevice(.coldWater(installationDate: .now), synced: false)
        let secondDevice = dataStore.insertDevice(.heating(installationDate: .now), synced: false)
        let thirdDevice = dataStore.insertDevice(.warmWater(), synced: true)

        //  WHEN
        try? await dataStore.syncDevices([firstDevice, secondDevice, thirdDevice])

        //  THEN
        let storedDevices = dataStore.getStoredDevices()
        XCTAssertEqual(storedDevices.count, 3)
        XCTAssertFalse(storedDevices[0].synced)
        XCTAssertFalse(storedDevices[1].synced)
        XCTAssertTrue(storedDevices[2].synced)
    }
}
