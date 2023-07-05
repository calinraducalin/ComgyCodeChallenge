//
//  DeviceDetailsViewModelTests.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import XCTest
import CoreData
@testable import Meter_Installation

@MainActor
final class DeviceDetailsViewModelTests: XCTestCase {

    var device: Device!

    override func setUp() {
        device = Device(context: DataStorage.test.viewContext)
    }

    override func tearDown() {
        DataStorage.test.viewContext.delete(device)
    }

    func testShouldShowCtaButtonWhenDeviceIsNotInstalled() {
        //  GIVEN
        device.installationDate = nil

        //  WHEN
        let viewModel = DeviceDetailsViewModel(device: device) {}

        //  THEN
        XCTAssertTrue(viewModel.shouldShowCtaButton)
    }

    func testShouldShowCtaButtonWhenDeviceIsInstalledAnNotSynced() {
        //  GIVEN
        device.installationDate = .now
        device.synced = false

        //  WHEN
        let viewModel = DeviceDetailsViewModel(device: device) {}

        //  THEN
        XCTAssertTrue(viewModel.shouldShowCtaButton)
    }

    func testShouldShowCtaButtonWhenDeviceIsInstalledAndSynced() {
        //  GIVEN
        device.installationDate = .now
        device.synced = true

        //  WHEN
        let viewModel = DeviceDetailsViewModel(device: device) {}

        //  THEN
        XCTAssertFalse(viewModel.shouldShowCtaButton)
    }

    func testCtaButtonRoleWhenDeviceIsInstalled() {
        //  GIVEN
        device.installationDate = .now

        //  WHEN
        let viewModel = DeviceDetailsViewModel(device: device) {}

        //  THEN
        XCTAssertEqual(viewModel.ctaButtonRole, .destructive)
    }

    func testCtaButtonRoleWhenDeviceIsNotInstalled() {
        //  GIVEN
        device.installationDate = nil

        //  WHEN
        let viewModel = DeviceDetailsViewModel(device: device) {}

        //  THEN
        XCTAssertEqual(viewModel.ctaButtonRole, .none)
    }

    func testCtaButtonActionWhenDeviceIsInstalled() {
        //  GIVEN
        device.installationDate = .now
        let viewModel = DeviceDetailsViewModel(device: device) {}

        //  WHEN
        viewModel.ctaButtonAction()

        //  THEN
        XCTAssertTrue(viewModel.isShowingConfirmation)
    }

    func testCtaButtonActionWhenDeviceIsNotInstalled() {
        //  GIVEN
        device.installationDate = nil
        let viewModel = DeviceDetailsViewModel(device: device) {}

        //  WHEN
        viewModel.ctaButtonAction()

        //  THEN
        XCTAssertTrue(viewModel.shouldDismiss)
    }

    func testConfirmedCtaButtonAction() {
        //  GIVEN
        var primaryActionCalled = false
        let viewModel = DeviceDetailsViewModel(device: device) {
            primaryActionCalled = true
        }

        //  WHEN
        viewModel.confirmedCtaButtonAction()

        //  THEN
        XCTAssertTrue(primaryActionCalled)
        XCTAssertTrue(viewModel.shouldDismiss)
    }


}
