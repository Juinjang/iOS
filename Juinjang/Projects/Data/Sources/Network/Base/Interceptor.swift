//
//  Interceptor.swift
//  Data
//
//  Created by 조유진 on 2/14/26.
//

import Combine
import Foundation

import DIKit
@preconcurrency import Domain

import Alamofire

final class Interceptor: RequestInterceptor {
    private let userDefaultsStorage: KeyValueStorage
    private let authType: AuthorizationType
    
    init(
        userDefaultsStorage: KeyValueStorage = DIContainer.shared.resolve(),
        authType: AuthorizationType
    ) {
        self.userDefaultsStorage = userDefaultsStorage
        self.authType = authType
    }
    
    func adapt(
        _ urlRequest: URLRequest,
        for session: Session,
        completion: @escaping (Result<URLRequest, any Error>) -> Void
    ) {
        var request = urlRequest
        
        if authType == .bearer, let accessToken = getAccessToken() {
            request.addValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        }
        
        completion(.success(request))
    }
}

private extension Interceptor {
    func getAccessToken() -> String? {
        return userDefaultsStorage.get(String.self, for: .accessToken)
    }
}
