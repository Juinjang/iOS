//
//  JuinjangError.swift
//  Common
//
//  Created by 조유진 on 3/8/26.
//

import Foundation

// MARK: - 앱 공통 에러 타입

public enum JuinjangError: Error, Equatable, Sendable {
    case success
    
    case badRequest(String?)           // 400
    case unauthorized(String?)         // 401
    case forbidden(String?)            // 403
    case notFound(String?)             // 404
    case conflict(String?)             // 409
    case unprocessableEntity(String?)  // 422
    case tooManyRequests(String?)      // 429

    case internalServerError(String?)  // 500
    case serviceUnavailable(String?)   // 503

    case networkError(String?)         // 네트워크 연결 실패
    case decodingError(String?)        // JSON 파싱 실패
    case unknown(code: String, message: String?)  // 매핑되지 않는 코드

    // MARK: - 서버 code → enum 매핑

    public init(code: String, message: String?) {
        switch code {
        case "200":  self = .success
        case "400":  self = .badRequest(message)
        case "401":  self = .unauthorized(message)
        case "403":  self = .forbidden(message)
        case "404":  self = .notFound(message)
        case "409":  self = .conflict(message)
        case "422":  self = .unprocessableEntity(message)
        case "429":  self = .tooManyRequests(message)
        case "500":  self = .internalServerError(message)
        case "503":  self = .serviceUnavailable(message)
        default:     self = .unknown(code: code, message: message)
        }
    }
}

extension JuinjangError {
    /// 서버 응답 code 문자열
    public var code: String {
        switch self {
        case .success:                return "200"
        case .badRequest:             return "400"
        case .unauthorized:           return "401"
        case .forbidden:              return "403"
        case .notFound:               return "404"
        case .conflict:               return "409"
        case .unprocessableEntity:    return "422"
        case .tooManyRequests:        return "429"
        case .internalServerError:    return "500"
        case .serviceUnavailable:     return "503"
        case .networkError:           return "NETWORK"
        case .decodingError:          return "DECODING"
        case .unknown(let code, _):   return code
        }
    }

    /// 에러 메시지
    public var message: String {
        switch self {
        case .success:                          return "성공"
        case .badRequest(let message):          return message ?? "잘못된 요청입니다"
        case .unauthorized(let message):        return message ?? "인증이 만료되었습니다"
        case .forbidden(let message):           return message ?? "접근 권한이 없습니다"
        case .notFound(let message):            return message ?? "요청한 데이터를 찾을 수 없습니다"
        case .conflict(let message):            return message ?? "데이터 충돌이 발생했습니다"
        case .unprocessableEntity(let message): return message ?? "처리할 수 없는 요청입니다"
        case .tooManyRequests(let message):     return message ?? "요청이 너무 많습니다. 잠시 후 다시 시도해주세요"
        case .internalServerError(let message): return message ?? "서버 오류가 발생했습니다"
        case .serviceUnavailable(let message):  return message ?? "서비스 점검 중입니다"
        case .networkError(let message):        return message ?? "네트워크 연결을 확인해주세요"
        case .decodingError(let message):       return message ?? "데이터 처리 중 오류가 발생했습니다"
        case .unknown(_, let message):          return message ?? "알 수 없는 오류가 발생했습니다"
        }
    }

    /// 재시도 가능한 에러인지 여부
    public var isRetryable: Bool {
        switch self {
        case .networkError, .internalServerError,
             .serviceUnavailable, .tooManyRequests:
            return true
        default:
            return false
        }
    }

    /// 로그인 화면으로 이동해야 하는 에러인지
    public var requiresReauth: Bool {
        switch self {
        case .unauthorized, .forbidden:
            return true
        default:
            return false
        }
    }
}

// MARK: - LocalizedError

extension JuinjangError: LocalizedError {
    public var errorDescription: String? { message }
}

// MARK: - 팩토리 메서드 (클라이언트 로컬 에러용)

extension JuinjangError {

    public static func clientError(_ message: String? = nil) -> JuinjangError {
        .networkError(message)
    }

    public static func parsingError(_ message: String? = nil) -> JuinjangError {
        .decodingError(message)
    }
}
