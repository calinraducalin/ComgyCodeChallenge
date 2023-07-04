//
//  Device+.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import CoreData
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

extension Device {

    class func entity(with id: String, in context: NSManagedObjectContext) -> Device {
        let entity: Device
        let predicate = PredicateMaker.makeIDPredicate(id: id)
        if let existingEntity = findFirst(predicate: predicate, in: context) {
            entity = existingEntity
        } else {
            entity = Device(context: context)
            entity.id = id
        }
        return entity
    }

    class func findFirst(with id: String, in context: NSManagedObjectContext) -> Self? {
        let predicate = PredicateMaker.makeIDPredicate(id: id)
        return findFirst(predicate: predicate, in: context)
    }

    func entity(in context: NSManagedObjectContext) -> Self {
        let entity: Self

        if let existingEntity = try? context.existingObject(with: objectID) as? Self {
            entity = existingEntity
        } else {
            AppLogger.data.error("Could not find \(self) in context \(context)")
            entity = .init(context: context)
        }

        return entity
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
