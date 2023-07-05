//
//  DeviceResponse+Test.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import Foundation
@testable import Meter_Installation

extension DeviceResponse {
    static var nowDate: Date { Date.now }

    static func coldWater(
        id: String = "coldWater",
        type: String = "cold_water",
        meterPointDescription: String = "meterPointDescription",
        installationDate: Date? = nil
    ) -> DeviceResponse {
        DeviceResponse(id: id, meterPointDescription: meterPointDescription, type: type, installationDate: installationDate)
    }

    static func warmWater(
        id: String = "warmWater",
        type: String = "warm_water",
        meterPointDescription: String = "meterPointDescription",
        installationDate: Date? = nil
    ) -> DeviceResponse {
        DeviceResponse(id: id, meterPointDescription: meterPointDescription, type: type, installationDate: installationDate)
    }

    static func heating(
        id: String = "heating",
        type: String = "heating",
        meterPointDescription: String = "meterPointDescription",
        installationDate: Date? = nil
    ) -> DeviceResponse {
        DeviceResponse(id: id, meterPointDescription: meterPointDescription, type: type, installationDate: installationDate)
    }

    static func unsupported(
        id: String = "unsupported",
        type: String = "unsupported_type",
        meterPointDescription: String = "meterPointDescription",
        installationDate: Date? = nil
    ) -> DeviceResponse {
        DeviceResponse(id: id, meterPointDescription: meterPointDescription, type: type, installationDate: installationDate)
    }

    static func invalid() -> DeviceResponse {
        DeviceResponse(id: "invalid", meterPointDescription: nil, type: nil, installationDate: nil)
    }
}
