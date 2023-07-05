//
//  MainViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    let dataStore: DataStorage

    init(dataStore: DataStorage = .shared) {
        self.dataStore = dataStore
    }

}
