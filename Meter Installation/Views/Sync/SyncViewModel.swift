//
//  SyncViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

@MainActor
final class SyncViewModel: ObservableObject {
    let dataProvider: DeviceManagementDataProviding
    @Published private(set) var state: ListViewState = .success
    
    init(dataProvider: DeviceManagementDataProviding = DataProvider.shared) {
        self.dataProvider = dataProvider
    }

    func uninstallDevice(_ device: Device) {
        guard !device.synced else { return }
        dataProvider.updateDevice(device, isInstalled: false)
    }
}
