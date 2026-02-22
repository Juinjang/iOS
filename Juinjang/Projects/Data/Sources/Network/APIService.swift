//
//  APIService.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

import Combine
import Foundation

import Alamofire

protocol APIServiceProtocol {
    func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T
}

final class APIService: APIServiceProtocol {
    @MainActor static let shared = APIService()
    
    // MARK: - Properties
    
    private let decoder: JSONDecoder

    // MARK: - Init

    private init(decoder: JSONDecoder = JSONDecoder()) {
        self.decoder = decoder
    }
    
    public func request<T: Decodable>(
        _ target: APITarget,
        responseType: T.Type
    ) async throws -> T {
        let request = AF.request(
            target,
            interceptor: Interceptor(authType: target.authorizationType)
        )
        
        let responseData: Data = try await request
            .serializingData()
            .value
        
        printResponseLog(endPoint: target.endPoint, data: responseData)
        return try decode(responseType, from: responseData)
    }
    
    private func decode<T: Decodable>(_ type: T.Type, from data: Data) throws -> T {
        do {
            return try decoder.decode(type, from: data)
        } catch {
            throw AFError.responseSerializationFailed(reason: .decodingFailed(error: error))
        }
    }
    
    private func printResponseLog(endPoint: String, data: Data) {
        print("📮 RESPONSE: \(endPoint)")

        guard
            let jsonObject = try? JSONSerialization.jsonObject(with: data),
            let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted]),
            let prettyString = String(data: prettyData, encoding: .utf8)
        else {
            print(String(data: data, encoding: .utf8) ?? "Invalid utf8")
            return
        }

        print(prettyString)
    }
}
