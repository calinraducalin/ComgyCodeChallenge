//
//  ListViewState.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

enum ViewState: Equatable {
    case success
    case loading
    case failure(_ error: MeterInstallationError)
}
