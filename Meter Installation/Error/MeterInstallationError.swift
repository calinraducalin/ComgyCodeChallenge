//
//  MeterInstallationError.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

enum MeterInstallationError: Error {
    case networkError
    case missingData
    case batchInsertError
    case wrongDataFormat(error: Error)
    case unkownError(_ error: Error)
}

extension MeterInstallationError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .networkError:
            return "A network error occured."
        case .batchInsertError:
            return "Batch insert error occured."
        case .missingData:
            return "Missing data"
        case let .wrongDataFormat(error):
            return "Wrong Data format error: \(error.localizedDescription)"
        case let .unkownError(error):
            return "An unknown error occured: \(error.localizedDescription)"
        }
    }
}
