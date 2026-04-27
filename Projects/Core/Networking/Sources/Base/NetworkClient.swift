import Foundation

import Common

// MARK: - Network Client
/// APIService를 감싸서 에러 매핑을 자동 처리합니다.
/// Feature별 API 구현에서 이 클라이언트를 사용합니다.

public protocol NetworkClientProtocol: Sendable {
    func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T

    func upload<T: Decodable>(
        _ target: APITarget,
        multipart: MultipartData,
        responseType: T.Type
    ) async throws -> T
}

public final class NetworkClient: NetworkClientProtocol, @unchecked Sendable {

    private let apiService: APIServiceProtocol

    public init(apiService: APIServiceProtocol = APIService.shared) {
        self.apiService = apiService
    }

    public func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T {
        do {
            return try await apiService.request(target, responseType: responseType)
        } catch {
            throw APIMapper.mapNetworkError(error)
        }
    }

    public func upload<T: Decodable>(
        _ target: APITarget,
        multipart: MultipartData,
        responseType: T.Type
    ) async throws -> T {
        do {
            return try await apiService.upload(target, multipart: multipart, responseType: responseType)
        } catch {
            throw APIMapper.mapNetworkError(error)
        }
    }
}
