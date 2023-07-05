//
//  DataClient.swift
//  Meter Installation
//
//  Created by Radu Calin Calin on 03.07.2023.
//

import Foundation

protocol DataClient {
    func getData(from: URL) async throws -> Data
    @discardableResult
    func patchData(_ data: Data, to: URL) async throws -> Data
}

extension DataClient {
    var baseURL: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "comgy.io"
        guard let url = components.url else {
            fatalError("Invalid URL!")
        }
        return url
    }

    func makeURL(endpoint: String) -> URL {
        baseURL.appendingPathComponent(endpoint)
    }

    func makeDecoder() -> JSONDecoder {
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .iso8601
        return decoder
    }

    func makeEncoder() -> JSONEncoder {
        let encoder = JSONEncoder()
        encoder.dateEncodingStrategy = .iso8601
        return encoder
    }
}

extension URLSession: DataClient {
    func getData(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        return try await executeRequest(request)
    }
    func patchData(_ data: Data, to url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.httpMethod = "PATCH"
        request.httpBody = data
        return try await executeRequest(request)
    }
}

private extension URLSession {
    func executeRequest(_ request: URLRequest) async throws -> Data {
        let validStatus = 200...299
        guard let (data, response) = try await self.data(for: request) as? (Data, HTTPURLResponse),
              validStatus.contains(response.statusCode) else {
            throw MeterInstallationError.network
        }

        return data
    }
}
