import OpenAPIRuntime
import Foundation
import HTTPTypes

package final class AuthenticationMiddleware {
    package var userID: String?
    private let client: String
    private let device: String
    private let deviceID: String
    private let version: String

    package init(
        userID: String?,
        client: String,
        device: String,
        deviceID: String,
        version: String
    ) {
        self.userID = userID
        self.client = client
        self.device = device
        self.deviceID = deviceID
        self.version = version
    }
}

extension AuthenticationMiddleware: ClientMiddleware {
    package func intercept(
        _ request: HTTPRequest,
        body: HTTPBody?,
        baseURL: URL,
        operationID: String,
        next: (HTTPRequest, HTTPBody?, URL) async throws -> (HTTPResponse, HTTPBody?)
    ) async throws -> (HTTPResponse, HTTPBody?) {
        var request = request
        request.headerFields[.authorization] = authHeaders()
        return try await next(request, body, baseURL)
    }

    private func authHeaders() -> String {
        let fields = [
            "UserId": userID,
            "Client": client,
            "Version": version,
            "Device": device,
            "DeviceId": deviceID,
        ]
            .compactMap { key, value in
                value.map { "\(key)=\($0)" }
            }
            .joined(separator: ", ")
        return "Emby \(fields)"
    }
}
