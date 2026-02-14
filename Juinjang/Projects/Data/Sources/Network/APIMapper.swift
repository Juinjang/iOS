//
//  APIMapper.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

import Combine
import Foundation

import Domain

import Alamofire

enum APIMapper { }

extension APIMapper {
    // data 반환: CommonResponse<T> → T
    static func mapData<T: Decodable, Output>(
        _ response: ResultResponse<T>,
        successCodes: Set<String> = ["200"],
        transform: @escaping (T) -> Output,
        onEmptyData: (() -> Output)? = nil
    ) throws -> Output {
        guard successCodes.contains(response.code) else {
            throw JuinjangError(code: response.code, message: response.message)
        }

        if let result = response.result {
            return transform(result)
        }

        if let onEmptyData {
            return onEmptyData()
        }

        throw JuinjangError(code: response.code, message: response.message)
    }

    // code만 확인하면 되는 API
    static func mapVoid(
        _ response: VoidResponse,
        successCodes: Set<String> = ["200"]
    ) throws {
        guard successCodes.contains(response.code) else {
            throw JuinjangError(code: response.code, message: response.message)
        }
    }
    
    static func mapNetworkError(_ error: Error) -> JuinjangError {
        if let domainError = error as? JuinjangError {
            return domainError
        }

        if let afError = error as? AFError {
            // 필요 시 AFError 세분화 처리 가능
            print("🫠 \(afError.localizedDescription)")
            return JuinjangError.CLIENT_ERROR()
        }

        return JuinjangError.CLIENT_ERROR()
    }
}
