//
//  SignUpWebViewController.swift
//  juinjang
//
//  Created by 박도연 on 2/8/24.
//

import UIKit
import SnapKit
import Then
import WebKit
import Alamofire

var userAccessToken = ""
var userRefreshToken = ""
struct UserInfoResponse: Codable {
    let isSuccess: Bool
    let code: String
    let message: String
    let result: UserInfoResult
}

struct UserInfoResult: Codable {
    let nickname: String?
    let email: String
    let provider: String
}

class SignUpWebViewController: UIViewController {
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    var completionHandler: ((Bool) -> Void)? = nil
    
    func setAttributes() {
        let contentController = WKUserContentController()
        //contentController.add(self, name: "callBackHandler")
        
        let configuration = WKWebViewConfiguration() // contentController를 WKWebView와 연결하는 것을 도움
        configuration.userContentController = contentController
        
        webView = WKWebView(frame: .zero, configuration: configuration)
        self.webView?.navigationDelegate = self
        
        guard let url = URL(string: "http://juinjang1227.com:8080/api/auth/kakao"),
              let webView = webView
        else { return }
        let request = URLRequest(url: url) // URLRequest 생성해서
        webView.load(request) // webView가 URL 로드
    }
    
    func setupLayout(){
        guard let webView = webView else { return }
        
        view.addSubview(webView)
        webView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview()
            $0.leading.trailing.equalToSuperview()
        }
        
    }
    
    func loading(){
        print("LOADING....")
        let signupViewController = SignUpWebViewController()
         // 현재 내비게이션 컨트롤러가 nil인지 확인
        let navigationController = UINavigationController(rootViewController: signupViewController)
        if let windowScene = UIApplication.shared.connectedScenes
             .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
             if let window = windowScene.windows.first {
                 window.rootViewController = navigationController
            }
        }
    }
    
    func hasToken(){
        let mainViewController = MainViewController()
            // 현재 내비게이션 컨트롤러가 nil인지 확인
        if let navigationController = self.navigationController {
            // 내비게이션 컨트롤러 스택에 MainViewController를 push
            navigationController.pushViewController(mainViewController, animated: true)
            print("ToSViewController로 push됨") // 확인용 로그 추가
        } else {
            // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 MainViewController를 rootViewController로 설정
            let navigationController = UINavigationController(rootViewController: mainViewController)
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = navigationController
                }
            }
            print("ToSViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
        }
            
    }
    func noToken() {
            let toSViewController = ToSViewController()
            // 현재 내비게이션 컨트롤러가 nil인지 확인
            if let navigationController = self.navigationController {
                // 내비게이션 컨트롤러 스택에 MainViewController를 push
                navigationController.pushViewController(toSViewController, animated: true)
                print("ToSViewController로 push됨") // 확인용 로그 추가
            } else {
                // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 MainViewController를 rootViewController로 설정
                let navigationController = UINavigationController(rootViewController: toSViewController)
                if let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        window.rootViewController = navigationController
                    }
                }
                print("ToSViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
            }
        
    }
    func getUserInfo(userToken : String) {
        MainViewController().refreshToken()
        if userToken.isEmpty == false {
            // 로그아웃 API의 URL
            let urlString = "http://juinjang1227.com:8080/api/profile"
            
            // HTTP 요청 보내기
            AF.request(urlString, method: .get, headers: HTTPHeaders(["Authorization": "Bearer \(UserDefaultManager.shared.accessToken)"])).responseData { [self] response in
                switch response.result {
                case .success(let data):
                    // 응답 확인
                    if let httpResponse = response.response {
                        print("Status code: \(httpResponse.statusCode)")
                        //print("Token: \(UserDefaultManager.shared.accessToken)")
                    }
                    // 응답 데이터 출력
                    if let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                    // JSON 데이터 파싱
                    do {
                        let userInfoResponse = try JSONDecoder().decode(UserInfoResponse.self, from: data)
                        let email = userInfoResponse.result.email
                        let nickname = userInfoResponse.result.nickname
                        UserDefaultManager.shared.email = email
                        print("Email: \(UserDefaultManager.shared.email)")
                        print("Nickname : \(nickname ?? "")")
                        if nickname == nil {
                            noToken()
                        } else {
                            self.hasToken()
                        }
                    } catch {
                        print("Error parsing JSON: \(error)")
                    }
                case .failure(let error):
                    print("Error: \(error)")
                }
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setupLayout()
    }
}

extension SignUpWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("웹 뷰가 콘텐츠를 로드하는 중...")
        //self.getUserInfo(userToken: UserDefaultManager.shared.accessToken)
    }
    func webView(_ webView: WKWebView, didCommit navigation: WKNavigation!) {
        print("웹 뷰가 콘텐츠를 로드하는 중2...")
        
    }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("웹 뷰가 콘텐츠 로드를 완료했습니다.")
        webView.evaluateJavaScript("document.documentElement.innerText") { (result, error) in
            if let jsonString = result as? String {
                if let data = jsonString.data(using: .utf8) {
                    do {
                        
                        let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                        if let result = json["result"] as? [String: Any],
                            let accessToken = result["accessToken"] as? String,
                            let refreshToken = result["refreshToken"] as? String {
                            //self.getUserInfo(userToken: accessToken)
                            UserDefaultManager.shared.accessToken = accessToken
                            UserDefaultManager.shared.refreshToken = refreshToken
                            self.loading()
                            self.getUserInfo(userToken: UserDefaultManager.shared.accessToken)
                            //print("accessToken: \(UserDefaultManager.shared.accessToken)")
                            //print("refreshToken: \(UserDefaultManager.shared.refreshToken)")
                            if accessToken.isEmpty == false {
                                //self.dismiss(animated: false, completion: nil)
                            }
                        }
                    } catch {
                        print("JSON 파싱 오류: \(error.localizedDescription)")
                    }
                }
            } else if let error = error {
                print("JavaScript 오류: \(error.localizedDescription)")
            }
        }
        
    }
}

