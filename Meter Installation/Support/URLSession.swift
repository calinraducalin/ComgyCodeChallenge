//
//  MockURLProtocol.swift
//  Meter Installation
//
//  Created by Gernot Poetsch on 19.06.23.
//

import Foundation

/**
 
 This simulates a fictional Comgy API as realistically as possible. It should be used with `URLSession.comgy` and then using this URLSession like you would use a normal URLSession in any way you like.
 
 For more Info on the API Documentation see the (Readme)[README.md]
 
 ** THIS FILE SHOULD NOT BE CHANGED.  **
 
 */

extension URLSession {
    
    /// Use this URLSession instead of the shared one to access the Mocked Comgy API (see [Readme](Readme.md))
    static var comgy: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.protocolClasses = [MockURLProtocol.self]
        return URLSession(configuration: configuration)
    }
    
}















//MARK: - Only Private Methods Below.
// You do not need to read or understand these, the API documentation in the Readme should be enough.



//MARK: Configuration

private let scheme = "https"
private let host = "comgy.io"

private var initialDevices: [ServerStore.JSONDevice] = [
    ["id": "WWM-0001-12", "meterPointDescription": "Kitchen", "type": "warm_water", "installationDate": nil],
    ["id": "CWM-0012-62", "meterPointDescription": "Kitchen", "type": "cold_water", "installationDate": nil],
    ["id": "HEA-8127-29", "meterPointDescription": "Hallway", "type": "heating", "installationDate": nil],
    ["id": "HEA-5513-39", "meterPointDescription": "Hallway", "type": "heating", "installationDate": Date.now.formatted(.iso8601)]
]

//MARK: Mock Protocol

/// This protocol simulates the server. Do not change this class.
class MockURLProtocol: URLProtocol {
    
    private var mockTask: Task<Void, Never>?
    
    override class func canInit(with request: URLRequest) -> Bool {
        return true
    }
    
    override class func canInit(with task: URLSessionTask) -> Bool {
        return true
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    
    override func startLoading() {
        mockTask = Task {
            do {
                let (response, data) = try await handler(for: request)
                client?.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
                if let data {
                    client?.urlProtocol(self, didLoad: data)
                }
                client?.urlProtocolDidFinishLoading(self)
            } catch {
                client?.urlProtocol(self, didFailWithError: error)
            }
        }
    }
    
    override func stopLoading() {
        mockTask?.cancel()
    }
    
    
    /// Request handler,
    /// - Parameter request: The URL Request
    /// - Returns: Response and data to return to the client.
    /// - Throws: `URLError` with LocalizedDescription, to be in line with what regular code would get from an API
    /// - Note: There can be occasional loading times or HTTP errors!
    private func handler(for request: URLRequest) async throws ->  (HTTPURLResponse, Data?) {
        guard let url = request.url else { throw URLError(.unknown)}
        let components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        guard let components else { throw URLError(.badURL) }
        guard components.scheme == scheme else { throw URLError(.unsupportedURL, "URL needs to use \(scheme)") }
        guard components.host == host else { throw URLError(.cannotFindHost, "Host needs to be \(host)") }
        try await Task.sleep(for: .seconds(.random(in: 1.0 ... 3.0)))
        let pathComponents = url.pathComponents
        guard pathComponents.count >= 2, pathComponents[0] == "/" else {
            return failure(for: url, errorCode: 400, message: "Bad Request")
        }
        if (1...10).randomElement() == 5 {
            return failure(for: url, errorCode: 500, message: "Internal Server Error")
        }
        do {
            switch pathComponents[1] {
            case "devices":
                if pathComponents.count == 2, request.httpMethod == "GET" {
                    return success(for: url, jsonData: try await ServerStore.shared.devices())
                } else if pathComponents.count == 3, request.httpMethod == "PATCH" {
                    guard let bodyStream = request.httpBodyStream else {
                        return failure(for: url, errorCode: 400, message: "Body is missing")
                    }
                    let id = pathComponents[2]
                    let data = try await  ServerStore.shared.updateDevice(id: id, jsonData: try readStream(bodyStream))
                    return success(for: url, jsonData: data)
                } else {
                    return failure(for: url, errorCode: 400, message: "Bad Request")
                }
            default:
                return failure(for: url, errorCode: 404, message: "Not Found")
            }
        } catch {
            return failure(for: url, errorCode: 400, message: "Bad Request: \(error.localizedDescription)")
        }
    }
    
    private func readStream(_ stream: InputStream) throws -> Data {
        var data = Data()
        let bufferSize: Int = 16
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: bufferSize)
        stream.open()
        while stream.hasBytesAvailable {
            let readDat = stream.read(buffer, maxLength: bufferSize)
            data.append(buffer, count: readDat)
        }
        buffer.deallocate()
        stream.close()
        return data
    }
    
    private func failure(for url: URL, errorCode: Int, message: String) -> (HTTPURLResponse, Data?) {
        let data = message.data(using: .utf8)
        let response = HTTPURLResponse(url: url,
                                               statusCode: errorCode,
                                               httpVersion: "2.0",
                                               headerFields: nil)!
        return(response, data)
    }
    
    private func success(for url: URL, jsonData: Data?) -> (HTTPURLResponse, Data?) {
        if let jsonData {
            let response = HTTPURLResponse(url: url,
                                           mimeType: "text/json",
                                           expectedContentLength: jsonData.count,
                                           textEncodingName: "UTF-8")
            return (response, jsonData)
        } else {
            let response = HTTPURLResponse(url: url,
                                           statusCode: 200,
                                           httpVersion: "2.0",
                                           headerFields: nil)!
            return (response, nil)
        }
    }
    
}

//MARK: Server Store

private actor ServerStore {
    
    /// The device is a dictionary to be JSON codable. An in real code we would have an actual type safe model, but in a code challenge, we don;t want to spoil anything the applicant has to do on the client side.
    typealias JSONDevice = [String: Any?]
    
    enum Error: LocalizedError {
        case invalidIdentifier
        case invalidFormat
        case deviceNotFound(id: String)
        case invalidDateFormat
    }
    
    static let shared = ServerStore()
    
    private init() {
        self.storage = initialDevices
    }
    
    private var storage: [JSONDevice]
    
    func devices() async throws -> Data {
        try jsonData(from: storage)
    }
    
    func updateDevice(id: String, jsonData data: Data) async throws -> Data? {
        let dictionary = try JSONSerialization.jsonObject(with: data, options: .topLevelDictionaryAssumed)
        guard let dictionary = dictionary as? [String: Any] else { throw Error.invalidFormat }
        // Validate everything, and in case a validation fails, throw an error. Values are not written yet!
        let validatedDictionary: [String: Any?] = try dictionary.reduce(into: [:]) { partialResult, keyValue in
            partialResult[keyValue.key] = try validatedValue(keyValue.value, for: keyValue.key)
        }
        // Get the stored value and update with the validated new data
        guard let index = storage.firstIndex(where: {$0["id"] as? String == id}) else {
            throw Error.deviceNotFound(id: id)
        }
        let storedDevice = storage[index]
        storage[index] = storedDevice.merging(validatedDictionary, uniquingKeysWith: { old, new in new })
        return nil
    }
    
    private func validatedValue(_ value: Any, for key: String) throws -> Any? {
        switch key {
        case "id":
            guard let value = value as? String, !value.isEmpty else { throw Error.invalidIdentifier }
            return value
        case "meterPointDescription":
            guard let value = value as? String, !value.isEmpty else { throw Error.invalidFormat }
            return value
        case "type":
            //All types from the initial values are valid, the rest isn't
            let validTypes = initialDevices.compactMap { $0["type"] as? String }
            guard let value = value as? String, validTypes.contains(value) else { throw Error.invalidFormat }
            return value
        case "installationDate":
            if value is NSNull {
                return nil
            } else {
                guard let value = value as? String, let _ = ISO8601DateFormatter().date(from: value) else {
                    throw Error.invalidDateFormat
                }
                return value
            }
        default:
            throw Error.invalidFormat
        }
    }
    
    func jsonData(from object: Any) throws -> Data {
        try JSONSerialization.data(withJSONObject: object,
                                   options: [.prettyPrinted, .fragmentsAllowed, .sortedKeys])
    }
    
}

//MARK: Convenience Methods

extension URLError {
    /// Convenience initializer for filling the localizedDescription for URLError
    init(_ code: URLError.Code, _ localizedDescription: String) {
        self.init(code, userInfo: [kCFErrorLocalizedDescriptionKey as String: localizedDescription])
    }
}
