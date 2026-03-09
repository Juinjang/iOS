import Foundation

import Alamofire

// MARK: - API Target 프로토콜
/// 각 API 엔드포인트를 정의하는 프로토콜입니다.
/// Feature별 API enum이 이 프로토콜을 채택합니다.

public protocol APITarget: URLRequestConvertible {
    var baseURL: URL { get }
    var endPoint: String { get }
    var method: HTTPMethod { get }
    var authorizationType: AuthorizationType { get }
    var task: RequestTask { get }
}

// MARK: - 기본 구현

extension APITarget {

    public var baseURL: URL {
        guard let url = URL(string: URLConfiguration.baseURL) else {
            fatalError("[APITarget] URL 생성 실패 🙀")
        }
        return url
    }

    public func asURLRequest() throws -> URLRequest {
        let url = baseURL.appendingPathComponent(endPoint)
        var request = URLRequest(url: url)
        request.method = method
        request.timeoutInterval = 10

        #if DEBUG
        print("💌 REQUEST:", method.rawValue, endPoint)
        #endif

        switch task {
        case .requestPlain:
            return request
        case let .requestQuery(encodable):
            debugPrintEncodable(encodable)
            return try URLEncodedFormParameterEncoder.default.encode(
                encodable, into: request
            )
        case let .requestBody(encodable):
            debugPrintEncodable(encodable)
            return try JSONParameterEncoder.default.encode(
                encodable, into: request
            )
        }
    }

    // MARK: - Debug

    private func debugPrintEncodable(_ encodable: Encodable) {
        #if DEBUG
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted]

        if let data = try? encoder.encode(encodable),
           let string = String(data: data, encoding: .utf8) {
            print(string)
        }
        #endif
    }
}
