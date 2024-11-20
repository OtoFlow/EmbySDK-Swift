//
//  EmbyClient.swift
//  EmbyClient
//
//  Created by Xianhe Meng on 2024/11/19.
//

import OpenAPIRuntime
import OpenAPIURLSession
import Foundation
import AuthenticationMiddleware

public final class EmbyClient {
    public struct Configuration {
        public let serverURL: URL
        public let client: String
        public let version: String
        public let deviceName: String
        public let deviceID: String
        public let userID: String?

        public init(
            serverURL: URL,
            client: String,
            version: String,
            deviceName: String,
            deviceID: String,
            userID: String? = nil
        ) {
            self.serverURL = serverURL
            self.client = client
            self.version = version
            self.deviceName = deviceName
            self.deviceID = deviceID
            self.userID = userID
        }
    }

    public let configuration: Configuration

    let underlyingClient: any APIProtocol

    private(set) var authenticationMiddleware: AuthenticationMiddleware?

    public private(set) var accessToken: String?

    init(configuration: Configuration, underlyingClient: any APIProtocol) {
        self.configuration = configuration
        self.underlyingClient = underlyingClient
    }

    public convenience init(configuration: Configuration, accessToken: String? = nil) {
        let authenticationMiddleware = AuthenticationMiddleware(
            userID: configuration.userID,
            client: configuration.client,
            device: configuration.deviceName,
            deviceID: configuration.deviceID,
            version: configuration.version
        )

        self.init(
            configuration: configuration,
            underlyingClient: Client(
                serverURL: configuration.serverURL,
                configuration: .init(
                    dateTranscoder: .iso8601WithFractionalSeconds
                ),
                transport: URLSessionTransport(),
                middlewares: [
                    authenticationMiddleware
                ]
            )
        )

        self.authenticationMiddleware = authenticationMiddleware
        self.accessToken = accessToken
    }
}

extension EmbyClient {
    public func getPublicSystemInfo() async throws -> PublicSystemInfo {
        let response = try await underlyingClient.getSystemInfoPublic()
        let systemInfo = try response.ok.body.json
        return .init(
            localAdress: systemInfo.LocalAddress,
            localAdresses: systemInfo.LocalAddresses,
            wanAdress: systemInfo.WanAddress,
            remoteAdresses: systemInfo.RemoteAddresses,
            serverName: systemInfo.ServerName ?? "",
            version: systemInfo.Version,
            id: systemInfo.Id!
        )
    }

    public func login(username: String, password: String) async throws -> AuthenticationResult {
        let input = Operations.postUsersAuthenticatebyname.Input(
            headers: .init(
                X_hyphen_Emby_hyphen_Authorization: "",
                accept: [.init(contentType: .json)]
            ),
            body: .json(.init(Username: username, Pw: password))
        )

        let response = try await underlyingClient.postUsersAuthenticatebyname(input)
        let result = try response.ok.body.json

        guard let user = result.User,
              let userID = user.Id,
              let serverID = user.ServerId
        else {
            throw Error.dataMissing
        }

        authenticationMiddleware?.userID = user.Id
        accessToken = result.AccessToken

        return .init(
            user: .init(
                id: userID,
                name: user.Name ?? "",
                serverID: serverID,
                serverName: user.ServerName ?? "",
                dateCreated: user.DateCreated,
                primaryImageTag: user.PrimaryImageTag
            ),
            accessToken: result.AccessToken!,
            serverId: result.ServerId!
        )
    }
}

extension EmbyClient {
    enum Error: Swift.Error {
        case dataMissing
    }
}