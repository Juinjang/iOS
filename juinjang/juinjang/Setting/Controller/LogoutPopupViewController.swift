//
//  LogoutPopupViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/10/24.
//

import UIKit
import SnapKit
import Then
import Alamofire

class LogoutPopupViewController: UIViewController {
    
    let urlString = "http://juinjang1227.com:8080/api/auth/logout"
    
    let headers: HTTPHeaders = [
        "Content-Type" : "application/json",
        "Authorization" : "Bearer \(SignUpWebViewController().userRefreshToken)"
    ]
    
    private let popupView: LogoutPopupView
    @objc func no(_ sender: UIButton) {
        self.dismiss(animated: false, completion: nil)
    }
    
    @objc func yes(_ sender: UIButton) {
       
        print("logout() success.")
        
        AF.request(urlString, method: .post, encoding: JSONEncoding.default, headers: headers).responseJSON { response in
            switch response.result {
            case .success(let value):
                print("Response: \(value)")
                // 서버 응답을 처리하는 코드를 여기에 추가합니다.
            case .failure(let error):
                print("Error: \(error.localizedDescription)")
            }
        }
        
        let signupViewController = SignUpViewController()
        let vc = SignUpWebViewController()
        vc.userAccessToken = ""

        // 현재 내비게이션 컨트롤러가 nil인지 확인
        if let navigationController = self.navigationController {
            navigationController.pushViewController(signupViewController, animated: true)
            print("SignUpViewController로 push됨") // 확인용 로그 추가
        } else {
            // 현재 내비게이션 컨트롤러가 없는 경우, 새로운 내비게이션 컨트롤러를 시작하고 SignUpViewController를 rootViewController로 설정
            let navigationController = UINavigationController(rootViewController: signupViewController)
            if let windowScene = UIApplication.shared.connectedScenes
                .first(where: { $0 is UIWindowScene }) as? UIWindowScene {
                if let window = windowScene.windows.first {
                    window.rootViewController = navigationController
                }
            }
            print("SignUpViewController로 새로운 내비게이션 스택 시작됨") // 확인용 로그 추가
        }
    }
  
    init(name: String, email: String, ment: String) {
        self.popupView = LogoutPopupView(name: name, email: email, ment: ment)
        super.init(nibName: nil, bundle: nil)
        self.view.backgroundColor = .clear
        self.view.addSubview(self.popupView)
        self.popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}

