//
//  TestDataClient.swift
//  Meter InstallationTests
//
//  Created by Radu Calin Calin on 05.07.2023.
//

import Foundation
@testable import Meter_Installation

class TestDataClient: DataClient {
    private enum Constants {
        static let responseTime: ClosedRange<UInt64> = 1_000_000...5_000_000 // 1 to 5 milliseconds
    }
    let responseData: Data
    let error: Error?

    init(response: Encodable = "", error: Error? = nil) {
        self.error = error
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        let data = try? encoder.encode(response)
        responseData = data ?? Data()
    }

    func getData(from: URL) async throws -> Data {
        try await Task.sleep(nanoseconds: UInt64.random(in: Constants.responseTime))
        guard let error else { return responseData }
        throw error
    }

    func patchData(_ data: Data, to: URL) async throws -> Data {
        try await Task.sleep(nanoseconds: UInt64.random(in: Constants.responseTime))
        guard let error else { return responseData }
        throw error
    }
}
