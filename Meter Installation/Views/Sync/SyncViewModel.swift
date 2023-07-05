//
//  SyncViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

@MainActor
final class SyncViewModel: ObservableObject, ViewStateErrorHandler {
    typealias DeviceSyncManagementDataStore = DeviceManagementDataStore & DeviceSyncDataStore
    let dataStore: DeviceSyncManagementDataStore
    @Published private(set) var state: ViewState = .success
    @Published var isShowingError = false
    
    init(dataStore: DeviceSyncManagementDataStore = DataStorage.shared) {
        self.dataStore = dataStore
    }

    func uninstallDevice(_ device: Device) {
        guard !device.synced else { return }
        dataStore.updateDevice(device, isInstalled: false)
    }

    func syncDevices(_ devices: [Device]) async {
        state = .loading
        do {
            try await dataStore.syncDevices(devices)
            dataStore.markAsSyncedDevices(devices)
            state = .success
        } catch {
            let error: MeterInstallationError = error as? MeterInstallationError ?? .unknown
            state = .failure(error)
            isShowingError = true
        }
    }
}
