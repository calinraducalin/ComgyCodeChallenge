//
//  SyncViewModelTests.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import XCTest
import CoreData
import OSLog
@testable import Meter_Installation

@MainActor
final class SyncViewModelTests: XCTestCase {
    private var dataStore: DeviceListDataStoreMock!

    override func setUp() {
        dataStore = DeviceListDataStoreMock()
    }

    func testUpdateDeviceNotCalledWhenDeviceIsSynced() {
        //  GIVEN
        let device = Device(context: dataStore.viewContext)
        device.synced = true
        let viewModel = SyncViewModel(dataStore: dataStore)

        //  WHEN
        viewModel.uninstallDevice(device)

        //  THEN
        XCTAssertFalse(dataStore.updateDeviceCalled)
    }

    func testUpdateDeviceCalledWhenDeviceIsNotSynced() {
        //  GIVEN
        let device = Device(context: dataStore.viewContext)
        device.synced = false
        let viewModel = SyncViewModel(dataStore: dataStore)

        //  WHEN
        viewModel.uninstallDevice(device)

        //  THEN
        XCTAssertTrue(dataStore.updateDeviceCalled)
    }

    func testSyncDevicesSuccess() async {
        //  GIVEN
        let device = Device(context: dataStore.viewContext)
        let viewModel = SyncViewModel(dataStore: dataStore)

        //  WHEN
        await viewModel.syncDevices([device])

        //  THEN
        XCTAssertTrue(dataStore.syncDevicesCalled)
        XCTAssertEqual(viewModel.state, .success)
    }

    func testSyncDevicesFailure() async {
        //  GIVEN
        let device = Device(context: dataStore.viewContext)
        let viewModel = SyncViewModel(dataStore: dataStore)

        //  WHEN
        dataStore.error = .network
        await viewModel.syncDevices([device])

        //  THEN
        XCTAssertTrue(dataStore.syncDevicesCalled)
        XCTAssertEqual(viewModel.state, .failure(.network))
        XCTAssertTrue(viewModel.isShowingError)
    }

}


private class DeviceListDataStoreMock: SyncViewModel.DeviceSyncManagementDataStore {
    var updateDeviceCalled = false
    var syncDevicesCalled = false
    var error: MeterInstallationError?

    func updateDevice(_ device: Meter_Installation.Device, isInstalled: Bool) {
        updateDeviceCalled = true
    }

    func syncDevices(_ devices: [Meter_Installation.Device]) async throws {
        syncDevicesCalled = true
        guard let error else { return }
        throw error
    }

    var logger: Logger? = nil

    var client = DataStorage.test.client

    var viewContext: NSManagedObjectContext = DataStorage.test.makeNewTaskContext()

    func makeNewTaskContext() -> NSManagedObjectContext {
        viewContext
    }

    func backgroundTask(_ task: @escaping (NSManagedObjectContext) -> Void) async {}

    func resetAllData() throws {}

}
