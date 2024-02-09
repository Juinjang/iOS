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

class SignUpWebViewController: UIViewController {
    var webView: WKWebView?
    let indicator = UIActivityIndicatorView(style: .medium)
    
    var userAccessToken = ""
    var userRefreshToken = ""
    
   
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
    
    func hasToken(userToken : String) {
        if userAccessToken == userToken {
            let mainViewController = MainViewController()
            // 현재 내비게이션 컨트롤러가 nil인지 확인
            if let navigationController = self.navigationController {
                // 내비게이션 컨트롤러 스택에 MainViewController를 push
                navigationController.pushViewController(mainViewController, animated: true)
                print("MainViewController로 push됨") // 확인용 로그 추가
            } else {
                // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 MainViewController를 rootViewController로 설정
                let navigationController = UINavigationController(rootViewController: mainViewController)
                if let windowScene = UIApplication.shared.connectedScenes
                    .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                    if let window = windowScene.windows.first {
                        window.rootViewController = navigationController
                    }
                }
                print("MainViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
            }
        }    }
    override func viewDidLoad() {
        super.viewDidLoad()
        setAttributes()
        setupLayout()
    }
}

/*extension SignUpWebViewController: WKScriptMessageHandler {
    func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        print(message.body)
        if let data = message.body as? [String: Any] {
            userAccessToken = data["username"] as? String ?? ""
            //userRefreshToken = data["refreshToken"] as? String ?? ""
        }
        print("access:\(userAccessToken)")
        //print("refresh:\(userRefreshToken)")
        self.dismiss(animated: true, completion: nil)
    }
}*/
extension SignUpWebViewController: WKNavigationDelegate {
    func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
        print("웹 뷰가 콘텐츠를 로드하는 중...")
    }
        
    func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
        print("웹 뷰가 콘텐츠 로드를 완료했습니다.")
        webView.evaluateJavaScript("document.documentElement.innerText") { (result, error) in
            if let jsonString = result as? String {
                //print("JSON 코드: \(jsonString)")
                if let data = jsonString.data(using: .utf8) {
                    do {
                            let json = try JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                            if let result = json["result"] as? [String: Any],
                                let accessToken = result["accessToken"] as? String,
                                let refreshToken = result["refreshToken"] as? String {
                                self.userAccessToken = accessToken
                                self.hasToken(userToken: accessToken)
                                self.userRefreshToken = refreshToken
                                print("accessToken: \(self.userAccessToken)")
                                print("refreshToken: \(self.userRefreshToken)")
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
