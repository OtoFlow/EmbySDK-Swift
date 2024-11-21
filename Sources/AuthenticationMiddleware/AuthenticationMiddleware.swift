import OpenAPIRuntime
import Foundation
import HTTPTypes

package final class AuthenticationMiddleware {
    private let client: String
    private let device: String
    private let deviceID: String
    private let version: String

    package var userID: String?
    package var accessToken: String?

    package init(
        client: String,
        device: String,
        deviceID: String,
        version: String,
        userID: String?,
        accessToken: String?
    ) {
        self.client = client
        self.device = device
        self.deviceID = deviceID
        self.version = version
        self.userID = userID
        self.accessToken = accessToken
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
        request.headerFields[.init("X-Emby-Token")!]  = accessToken
        return try await next(request, body, baseURL)
    }

    private func authHeaders() -> String {
        let fields = [
            "Client": client,
            "Version": version,
            "Device": device,
            "DeviceId": deviceID,
            "UserId": userID,
        ]
            .compactMap { key, value in
                value.map { "\(key)=\($0)" }
            }
            .joined(separator: ", ")
        return "Emby \(fields)"
    }
}
