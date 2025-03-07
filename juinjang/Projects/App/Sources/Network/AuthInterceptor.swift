//
//  AuthInterceptor.swift
//  juinjang
//
//  Created by 조유진 on 5/29/24.
//

import Foundation
import Alamofire

final class AuthInterceptor: RequestInterceptor {
    // 네트워크 요청 직전 호출
    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, any Error>) -> Void) {
        var urlRequest = urlRequest
        
        urlRequest.setValue("Bearer \(UserDefaultManager.shared.accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(urlRequest))
    }
    
    // 네트워크 요청에 대해 에러 발생 시 호출
    func retry(_ request: Request, for session: Session, dueTo error: any Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == APIError.accessTokenExpired.rawValue else { // 액세스 토큰이 만료되지 않았을 때
            completion(.doNotRetry)
            return
        }
        
        refreshAccessToken { isSuccess in
            if isSuccess {
                print("갱신 성공")
                completion(.retry)
            } else {
                print("refresh token 만료됨, 로그인 필요")
                NotificationCenter.default.post(name: .refreshTokenExpired, object: nil, userInfo: nil)
                completion(.doNotRetry)
            }
        }
    }
    
    private func refreshAccessToken(completion: @escaping(Bool) -> Void) {
        print("refreshAccessToken")
        JuinjangAPIManager.shared.refreshAccessToken { isSuccess in
            completion(isSuccess)
        }
    }
}
