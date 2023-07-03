//
//  DataClient+Test.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

final class TestClient: DataClient {
    func getData(from url: URL) async throws -> Data {
        try await Task.sleep(nanoseconds: UInt64.random(in: 1_000_000...5_000_000))
        return testDevicesData
    }
}

private let testDevicesData: Data = """
    [
        {
        "id" : "WWM-0001-12",
        "installationDate" : "2023-06-22T15:13:34Z",
        "meterPointDescription" : "Kitchen",
        "type" : "warm_water"
        },
        {
        "id" : "WWM-0001-13",
        "installationDate" : nil,
        "meterPointDescription" : "Kitchen",
        "type" : "cold_water"
        },
        {
        "id" : "WWM-0001-14",
        "installationDate" : nil,
        "meterPointDescription" : "Kitchen",
        "type" : "heating"
        }
    ]
    """.data(using: .utf8)!
