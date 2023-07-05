//
//  MeterInstallationError.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

enum MeterInstallationError: Error, Equatable {
    case network
    case missingData
    case batchInsert
    case resetAllData
    case syncDevice
    case fetchDevices
    case unknown
}

extension MeterInstallationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .network:
            return "A network error occured."
        case .batchInsert:
            return "Batch insert error occured."
        case .missingData:
            return "Missing data."
        case .fetchDevices:
            return "An error occured while loading the devices."
        case .unknown:
            return "An unknown error occured."
        case .syncDevice:
            return "An error occured while syncing the device."
        case .resetAllData:
            return "An error occured while resetting the data."
        }
    }
}
