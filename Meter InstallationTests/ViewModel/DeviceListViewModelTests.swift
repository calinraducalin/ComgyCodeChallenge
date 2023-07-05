//
//  DeviceListViewModelTests.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import XCTest
import CoreData
import OSLog
@testable import Meter_Installation

@MainActor
final class DeviceListViewModelTests: XCTestCase {
    private var dataStore: DeviceListDataStoreMock!

    override func setUp() {
        dataStore = DeviceListDataStoreMock()
    }

    func testShouldAutoRefreshDataIsTrueInitially() {
        //  WHEN
        let viewModel = DeviceListViewModel(dataStore: dataStore)

        //  THEN
        XCTAssertTrue(viewModel.shouldAutoRefreshData)
    }

    func testUpdateDevicesSuccess() async {
        //  GIVEN
        let viewModel = DeviceListViewModel(dataStore: dataStore)

        //  WHEN
        await viewModel.updateDevices()

        //  THEN
        XCTAssertEqual(viewModel.state, .success)
        XCTAssertFalse(viewModel.shouldAutoRefreshData)
    }

    func testUpdateDevicesFailed() async {
        //  GIVEN
        dataStore.error = .network
        let viewModel = DeviceListViewModel(dataStore: dataStore)

        //  WHEN
        await viewModel.updateDevices()

        //  THEN
        XCTAssertEqual(viewModel.state, .failure(.network))
        XCTAssertTrue(viewModel.shouldAutoRefreshData)
    }

    func testFetchDevicesCalledInitially() async {
        //  GIVEN
        let viewModel = DeviceListViewModel(dataStore: dataStore)

        //  WHEN
        await viewModel.updateDevicesIfNeeded()

        //  THEN
        XCTAssertTrue(dataStore.fetchDevicesCalled)
    }

    func testFetchDevicesNotCalledRightAfterSuccessfulUpdate() async {
        //  GIVEN
        let viewModel = DeviceListViewModel(dataStore: dataStore)

        //  WHEN
        await viewModel.updateDevices()
        dataStore.fetchDevicesCalled = false
        await viewModel.updateDevicesIfNeeded()

        //  THEN
        XCTAssertFalse(dataStore.fetchDevicesCalled)
    }

    func testUpdateDeviceCalledWhenDeviceIsNotInstalled() {
        //  GIVEN
        let device = Device(context: dataStore.viewContext)
        device.installationDate = nil
        let viewModel = DeviceListViewModel(dataStore: dataStore)

        //  WHEN
        viewModel.installDevice(device)

        //  THEN
        XCTAssertTrue(dataStore.updateDeviceCalled)
    }

    func testUpdateDeviceNotCalledWhenDeviceIsInstalled() {
        //  GIVEN
        let device = Device(context: dataStore.viewContext)
        device.installationDate = .now
        let viewModel = DeviceListViewModel(dataStore: dataStore)

        //  WHEN
        viewModel.installDevice(device)

        //  THEN
        XCTAssertFalse(dataStore.updateDeviceCalled)
    }
}

private class DeviceListDataStoreMock: DeviceListViewModel.DeviceListDataStore {
    var fetchDevicesCalled = false
    var updateDeviceCalled = false
    var error: MeterInstallationError?

    func fetchDevices() async throws {
        fetchDevicesCalled = true
        guard let error else { return }
        throw error
    }

    func updateDevice(_ device: Meter_Installation.Device, isInstalled: Bool) {
        updateDeviceCalled = true
    }

    var logger: Logger? = nil

    var client = DataStorage.test.client

    var viewContext: NSManagedObjectContext = DataStorage.test.makeNewTaskContext()

    func makeNewTaskContext() -> NSManagedObjectContext { viewContext }

    func resetAllData() throws {}

}

