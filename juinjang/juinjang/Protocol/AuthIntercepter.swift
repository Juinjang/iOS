import Alamofire
import Kingfisher
import Foundation

final class APIInterceptor: RequestInterceptor {
    
    private var isTokenRefreshed = false {
        didSet {
            print("isTokenRefreshed: \(isTokenRefreshed)")
        }
    }

    static let shared = APIInterceptor()

    private init() {}

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("adapt 진입")
        
        if isTokenRefreshed {
            print("토큰 재발급 후 URLRequset 변경")
            let accessToken = UserDefaultManager.shared.accessToken
            var modifiedRequest = urlRequest
            modifiedRequest.setValue(accessToken, forHTTPHeaderField: "accessToken")
            
            isTokenRefreshed = false
            
            completion(.success(modifiedRequest))
        } else {
            completion(.success(urlRequest))
        }
    }

    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401, let pathComponents =
                request.request?.url?.pathComponents,
                !pathComponents.contains("token")
        else {
            completion(.doNotRetryWithError(error))
            return
        }

        print("retry 코드:", response.statusCode)
        // 토큰 갱신 API 호출
        let url = URL(string: "http://juinjang1227.com:8080/api/auth/regenerate-token")!
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "POST"
        
        NetworkService.shared.authService.postRefreshToken { [weak self] result in
            switch result {
            case .success(let result):
                guard let serverAccessToken = result?.data.accessToken, let serverRefreshToken = result?.data.refreshToken
                else {
                    completion(.doNotRetry)
                    return
                }
                
                let keyChainResult = KeyChainService.saveTokens(accessKey: serverAccessToken, refreshKey: serverRefreshToken)
                
                if keyChainResult.accessResult == true && keyChainResult.refreshResult == true {
                    self?.isTokenRefreshed = true
                    
                    guard var urlRequest = request.request
                    else {
                        completion(.doNotRetry)
                        return
                    }
                    completion(.retry)
                } else {
                    completion(.doNotRetry)
                }
            case .unAuthorized:
                completion(.doNotRetry)
                print("postRefreshToken 도 만료")
            case .decodeErr, .networkFail:
                completion(.doNotRetry)
            default:
                completion(.doNotRetry)
            }
        }
    }
}
