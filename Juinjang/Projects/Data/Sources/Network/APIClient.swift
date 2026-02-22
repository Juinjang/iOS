//
//  APIClient.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

import Foundation

protocol APIClientProtocol {
    func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T
}

final class APIClient: APIClientProtocol {
    private let apiService: APIServiceProtocol

    init(apiService: APIServiceProtocol) {
        self.apiService = apiService
    }

    @MainActor
    convenience init() {
        self.init(apiService: APIService.shared)
    }

    func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T {
        do {
            return try await apiService.request(target, responseType: responseType)
        } catch {
            throw APIMapper.mapNetworkError(error)
        }
    }
}

