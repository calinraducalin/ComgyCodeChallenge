//
//  Device+.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import SwiftUI

extension Device {
    var isInstalled: Bool { installationDate != nil }
    var identifier: String { id ?? "" }
    var deviceType: DeviceType { .init(rawValue: type ?? "") ?? .unknown }
    var meterPointText: String { meterPointDescription ?? "" }
    var status: DeviceStatus {
        guard synced else { return .unsynced }
        return isInstalled ? .installed : .uninstalled
    }
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

    var systemImageName: String {
        switch self {
        case .warmWater: return "water.waves.and.arrow.up"
        case .coldWater: return "water.waves.and.arrow.down"
        case .heating: return "heater.vertical"
        case .unknown: return "questionmark.square"
        }
    }

    var imageColor: Color {
        switch self {
        case .warmWater: return .orange
        case .coldWater: return .blue
        case .heating: return .orange
        case .unknown: return .red
        }
    }
}

enum DeviceStatus {
    case installed
    case unsynced
    case uninstalled
}

extension DeviceStatus {
    var systemImageName: String { "circle.fill" }

    var imageColor: Color {
        switch self {
        case .installed: return .green
        case .uninstalled: return .red
        case .unsynced: return .orange
        }
    }
}
