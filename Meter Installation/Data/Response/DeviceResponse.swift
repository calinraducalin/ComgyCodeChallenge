//
//  DeviceResponse.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

struct DeviceResponse: Codable {
    let id: String
    let meterPointDescription: String?
    let type: String?
    let installationDate: Date?
}

extension DeviceResponse {
    var isValid: Bool { meterPointDescription != nil && type != nil }
}

