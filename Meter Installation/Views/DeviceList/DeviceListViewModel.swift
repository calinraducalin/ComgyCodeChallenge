//
//  DeviceListViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

@MainActor
final class DeviceListViewModel: ObservableObject, ViewStateErrorHandler {
    typealias DeviceListDataStore = DeviceDataStore & DeviceManagementDataStore

    let dataStore: DeviceListDataStore
    @Published private(set) var state: ViewState = .success
    @Published var searchText: String = ""
    @Published var isShowingError = false

    private var lastUpdated: Date?

    init(dataStore: DeviceListDataStore = DataStorage.shared) {
        self.dataStore = dataStore
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
            try await dataStore.fetchDevices()
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
        dataStore.updateDevice(device, isInstalled: true)
    }
}
