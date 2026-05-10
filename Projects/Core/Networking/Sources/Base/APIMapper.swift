import Foundation

import Common

import Alamofire

// MARK: - API 응답 매퍼

public enum APIMapper { }

extension APIMapper {

    // MARK: - 데이터 응답 매핑: ResultResponse<T> → Output

    public static func mapData<T: Decodable, Output>(
        _ response: ResultResponse<T>,
        successCodes: Set<String> = ["COMMON200"],
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

    // MARK: - Void 응답 매핑

    public static func mapVoid(
        _ response: VoidResponse,
        successCodes: Set<String> = ["COMMON200"]
    ) throws {
        guard successCodes.contains(response.code) else {
            throw JuinjangError(code: response.code, message: response.message)
        }
    }

    // MARK: - 네트워크 에러 매핑

    public static func mapNetworkError(_ error: Error) -> JuinjangError {
        if let domainError = error as? JuinjangError {
            return domainError
        }
        
        if let afError = error as? AFError {
            #if DEBUG
            print("🫠 \(afError.localizedDescription)")
            #endif

            switch afError {
            case .responseSerializationFailed:
                return .decodingError(afError.localizedDescription)
            case .sessionTaskFailed(let urlError as URLError):
                return mapURLError(urlError)
            default:
                return .clientError(afError.localizedDescription)
            }
        }

        // URLError 직접 처리
        if let urlError = error as? URLError {
            return mapURLError(urlError)
        }

        return .clientError(error.localizedDescription)
    }

    // MARK: - URLError 세분화

    private static func mapURLError(_ error: URLError) -> JuinjangError {
        switch error.code {
        case .notConnectedToInternet, .networkConnectionLost:
            return .networkError("인터넷 연결을 확인해주세요")
        case .timedOut:
            return .networkError("요청 시간이 초과되었습니다")
        case .cancelled:
            return .networkError("요청이 취소되었습니다")
        default:
            return .networkError(error.localizedDescription)
        }
    }
}
