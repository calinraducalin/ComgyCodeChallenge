//
//  Device+.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation


extension Device {
    var identifier: String { id ?? "" }
    var deviceType: DeviceType { .init(rawValue: type ?? "") ?? .unknown }
    var meterPointText: String { meterPointDescription ?? "" }
}

enum DeviceType: String {
    case warmWater = "warm_water"
    case coldWater = "cold_water"
    case heating = "heating"
    case unknown = ""
}

extension DeviceType {
    var description: String {
        switch self {
        case .warmWater: return "Warm water"
        case .coldWater: return "Cold water"
        case .heating: return "Heating"
        case .unknown: return "Unknown"
        }
    }
}
