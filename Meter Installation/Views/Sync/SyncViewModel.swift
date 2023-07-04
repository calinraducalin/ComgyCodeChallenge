//
//  SyncViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 04.07.2023.
//

import Foundation

@MainActor
final class SyncViewModel: ObservableObject {
    let dataProvider: DeviceDataProviding
    @Published private(set) var state: ListViewState = .success
    
    init(dataProvider: DeviceDataProviding = DataProvider.shared) {
        self.dataProvider = dataProvider
    }
}
