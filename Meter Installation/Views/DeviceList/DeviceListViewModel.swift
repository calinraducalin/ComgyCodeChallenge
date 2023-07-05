//
//  DeviceListViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

@MainActor
final class DeviceListViewModel: ObservableObject, ViewStateErrorHandler {
    typealias DevicesDataProviding = DeviceDataProviding & DeviceManagementDataProviding

    let dataProvider: DevicesDataProviding
    @Published private(set) var state: ViewState = .success
    @Published var searchText: String = ""
    @Published var isShowingError = false

    private var lastUpdated: Date?

    init(dataProvider: DevicesDataProviding = DataProvider.shared) {
        self.dataProvider = dataProvider
    }

    var shouldAutoRefreshData: Bool {
        guard let lastUpdated else { return true }
        let minutesSinceLastUpdated = Calendar.current.dateComponents([.minute], from: lastUpdated, to: .now).minute ?? .zero
        return minutesSinceLastUpdated > 10
    }

    func updateDevicesIfNeeded() async {
        guard shouldAutoRefreshData else { return }
        await updateDevices()
    }

    func updateDevices() async {
        state = .loading
        do {
            try await dataProvider.fetchDevices()
            lastUpdated = .now
            state = .success
        } catch {
            let error = error as? MeterInstallationError ?? MeterInstallationError.unknown
            state = .failure(error)
            isShowingError = true
        }
    }

    func installDevice(_ device: Device) {
        guard !device.isInstalled else { return }
        dataProvider.updateDevice(device, isInstalled: true)
    }
}
