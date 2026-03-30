import Foundation

import Common

import Alamofire

// MARK: - API Service 프로토콜

public protocol APIServiceProtocol: Sendable {
    func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T
}

// MARK: - API Service 구현

public final class APIService: APIServiceProtocol, @unchecked Sendable {

    public static let shared = APIService()

    private let decoder: JSONDecoder

    public init(
        decoder: JSONDecoder = JSONDecoder()
    ) {
        self.decoder = decoder
    }

    public func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T {

        let request = AF.request(
            target,
            interceptor: NetworkInterceptor(
                authType: target.authorizationType
            )
        )

        let responseData: Data = try await request
            .serializingData()
            .value

        #if DEBUG
        printResponseLog(endPoint: target.endPoint, data: responseData)
        #endif

        return try decode(responseType, from: responseData)
    }

    // MARK: - Private

    private func decode<T: Decodable>(
        _ type: T.Type,
        from data: Data
    ) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw AFError.responseSerializationFailed(
                reason: .decodingFailed(error: error)
            )
        }
    }

    private func printResponseLog(endPoint: String, data: Data) {
        print("📮 RESPONSE: \(endPoint)")

        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(
                withJSONObject: jsonObject,
                options: [.prettyPrinted]
            ),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            print(String(data: data, encoding: .utf8) ?? "Invalid utf8")
            return
        }

        print(prettyString)
    }
}
