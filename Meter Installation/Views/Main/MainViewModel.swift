//
//  MainViewModel.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

@MainActor
final class MainViewModel: ObservableObject {
    let dataProvider: DataProviding

    init(dataProvider: DataProviding = DataProvider.shared) {
        self.dataProvider = dataProvider
    }

}
