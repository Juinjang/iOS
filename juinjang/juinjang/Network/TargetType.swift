//
//  TargetType.swift
//  juinjang
//
//  Created by 강동영 on 2/24/25.
//

import Foundation
import Alamofire

protocol TargetType: URLRequestConvertible {
    var baseURL: String { get }
    var header: [String: String] { get }
    var path: String { get }
    var method: HTTPMethod { get }
    var queryItems: [URLQueryItem] { get }
    var parameters: [String: Any] { get }
}

extension TargetType {
    func createURL() -> URL? {
        var urlComponents = URLComponents(string: baseURL.appending(path))
        var items = [URLQueryItem]()
        
        queryItems.forEach { items.append($0) }
        urlComponents?.queryItems = items
        
        return urlComponents?.url
    }
}
