//
//  DataClient+Test.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import CoreData

final class PreviewClient: DataClient {
    func getData(from url: URL) async throws -> Data { previewDevicesData }
    func patchData(_ data: Data, to: URL) async throws -> Data { Data() }
}

private let previewDevicesData: Data = {
    let devices: [DeviceResponse] = [
        DeviceResponse(id: "WWM-0001-12", meterPointDescription: "Kitchen", type: "warm_water", installationDate: Date()),
        DeviceResponse(id: "WWM-0001-13", meterPointDescription: "Hallway", type: "heating", installationDate: nil),
        DeviceResponse(id: "WWM-0001-14", meterPointDescription: "Kitchen", type: "cold_water", installationDate: Date()),
        DeviceResponse(id: "WWM-0001-15", meterPointDescription: "Garage", type: "unsupported", installationDate: nil),
    ]
    let encoder = JSONEncoder()
    encoder.dateEncodingStrategy = .iso8601
    let data = try? encoder.encode(devices)
    return data ?? Data()
}()
