//
//  DeviceListViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

@MainActor
final class DeviceListViewModel: ObservableObject {
    let dataProvider: DeviceDataProviding
    @Published private(set) var state: ListViewState = .synced
    @Published var searchText: String = ""

    private var lastUpdated: Date?

    init(dataProvider: DeviceDataProviding = DataProvider.shared) {
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
        state = .syncing
        do {
            try await dataProvider.fetchDevices()
            lastUpdated = .now
            state = .synced
        } catch {
            let error = error as? MeterInstallationError ?? MeterInstallationError.unkownError(error)
            print(error.localizedDescription)
            state = .failed
        }
    }
}
