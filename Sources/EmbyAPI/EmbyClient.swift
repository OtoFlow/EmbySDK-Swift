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

        public init(
            serverURL: URL,
            client: String,
            version: String,
            deviceName: String,
            deviceID: String
        ) {
            self.serverURL = serverURL
            self.client = client
            self.version = version
            self.deviceName = deviceName
            self.deviceID = deviceID
        }
    }

    public let configuration: Configuration

    public private(set) var userID: String?
    public private(set) var accessToken: String?

    let underlyingClient: any APIProtocol

    private(set) var authenticationMiddleware: AuthenticationMiddleware?

    init(configuration: Configuration, underlyingClient: any APIProtocol) {
        self.configuration = configuration
        self.underlyingClient = underlyingClient
    }

    public convenience init(
        configuration: Configuration,
        userID: String? = nil,
        accessToken: String? = nil
    ) {
        let authenticationMiddleware = AuthenticationMiddleware(
            client: configuration.client,
            device: configuration.deviceName,
            deviceID: configuration.deviceID,
            version: configuration.version,
            userID: userID,
            accessToken: accessToken
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

        self.userID = userID
        self.accessToken = accessToken
        self.authenticationMiddleware = authenticationMiddleware
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
              let serverID = user.ServerId,
              let accessToken = result.AccessToken
        else {
            throw Error.dataMissing
        }

        self.userID = userID
        self.accessToken = accessToken
        authenticationMiddleware?.userID = userID
        authenticationMiddleware?.accessToken = accessToken

        return .init(
            user: .init(
                id: userID,
                name: user.Name ?? "",
                serverID: serverID,
                serverName: user.ServerName ?? "",
                dateCreated: user.DateCreated,
                primaryImageTag: user.PrimaryImageTag
            ),
            accessToken: accessToken,
            serverId: serverID
        )
    }
}

extension EmbyClient {
    enum Error: Swift.Error {
        case dataMissing
    }
}
