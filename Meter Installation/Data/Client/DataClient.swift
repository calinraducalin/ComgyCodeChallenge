//
//  DataClient.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

protocol DataClient {
    func getData(from: URL) async throws -> Data
}

extension URLSession: DataClient {
    func getData(from url: URL) async throws -> Data {
        let validStatus = 200...299
        guard let (data, response) = try await self.data(from: url, delegate: nil) as? (Data, HTTPURLResponse),
              validStatus.contains(response.statusCode) else {
            throw MeterInstallationError.networkError
        }

        return data
    }
}

extension DataClient {
    func makeURL(endpoint: String) -> URL {
        guard let url = URL(string: "https://comgy.io") else {
            fatalError("Invalid URL!")
        }
        return url.appendingPathComponent(endpoint)
    }

    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }
}
