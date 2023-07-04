//
//  SyncViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

@MainActor
final class SyncViewModel: ObservableObject {
    typealias DeviceSyncManaging = DeviceManagementDataProviding & DeviceSyncProviding
    let dataProvider: DeviceSyncManaging
    @Published private(set) var state: ListViewState = .success
    
    init(dataProvider: DeviceSyncManaging = DataProvider.shared) {
        self.dataProvider = dataProvider
    }

    func uninstallDevice(_ device: Device) {
        guard !device.synced else { return }
        dataProvider.updateDevice(device, isInstalled: false)
    }

    func syncDevices(_ devices: [Device]) async {
        state = .loading
        do {
            try await dataProvider.syncDevices(devices)
            dataProvider.markAsSyncedDevices(devices)
            state = .success
        } catch {
            let error: MeterInstallationError = error as? MeterInstallationError ?? .unkownError(error)
            print(error.localizedDescription)
            state = .failed
        }
    }
}
