//
//  TargetType.swift
//  juinjang
//
//  Created by 강동영 on 2/24/25.
//

import Foundation
import Alamofire
import RxSwift

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var parameters: [String: Any]? { get }
}

extension TargetType {
    var header: [String : String] {
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"
        ]
    }
    
    var baseURL: String {
        guard let baseURL = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("BASE_URL not found in Info.plist")
        }
        return baseURL
    }
    
    func request(_ provider: NetworkProvider<Self>) -> Single<Data> {
        return provider.request(self)
    }
    
    func createURL() -> URL? {
        var components = URLComponents(string: baseURL + path)
        if !queryItems.isEmpty {
            components?.queryItems = queryItems
        }
        return components?.url
    }
    
    func asURLRequest() throws -> URLRequest {
        guard let url = createURL() else {
            throw URLError(.badURL)
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.allHTTPHeaderFields = header

        if let parameters = parameters {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: [])
        }

        return request
    }
}
