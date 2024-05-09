//
//  SignUpViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/16.
//

import UIKit
import Then
import SnapKit
import Alamofire

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class SignUpViewController: UIViewController {

    lazy var juinjangLogoImage = UIImageView().then {
        $0.image = UIImage(named: "juinjang-logo-image")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var juinjangLogo = UIImageView().then {
        $0.image = UIImage(named: "juinjang-logo")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var kakaoLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "kakao-logo"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var appleLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "apple-logo"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var guideLabel = UILabel().then {
        $0.text = "소셜 계정을 통해\n로그인 또는 회원가입을 진행해 주세요."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = ColorStyle.darkGray
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        super.viewDidLoad()
        addSubViews()
        setupLayout()
    }
    
    func addSubViews() {
        [juinjangLogoImage,
         juinjangLogo,
         kakaoLoginButton,
         appleLoginButton,
         guideLabel].forEach { view.addSubview($0) }
    }
    
    func setupLayout() {
        // 주인장 로고 이미지 ImageView
        juinjangLogoImage.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(view.frame.height * 0.18)
        }

        // 주인장 로고 ImageView
        juinjangLogo.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(juinjangLogoImage.snp.bottom).offset(view.frame.height * 0.02)
        }

        // 로그인 Stack View
        let loginStackView = UIStackView(arrangedSubviews: [kakaoLoginButton, appleLoginButton])

        loginStackView.axis = .horizontal
        loginStackView.spacing = view.frame.width * 0.055

        view.addSubview(loginStackView)

        loginStackView.snp.makeConstraints {
            $0.top.equalTo(juinjangLogo.snp.bottom).offset(view.frame.height * 0.13)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.centerX.equalToSuperview()
        }

        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginStackView.snp.bottom).offset(view.frame.height * 0.06)
        }
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            loginWithApp()
        } else {
            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
            loginWithWeb()
        }
            
    }
}


extension SignUpViewController {

    // 카카오톡 앱으로 로그인
    func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                self.getUserInfo()
                self.sendPostRequest(email: UserDefaultManager.shared.email, nickname: UserDefaultManager.shared.nickname)
            }
        }
    }

    // 카카오톡 웹으로 로그인
    func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                self.getUserInfo()
                self.sendPostRequest(email: UserDefaultManager.shared.email, nickname: UserDefaultManager.shared.nickname)
            }
        }
    }
    func getUserInfo() {
        UserApi.shared.me {(user, error) in
            if let error = error {
                print(error)
            } else {
                if let kakaoUser = user {
                    if let email = kakaoUser.kakaoAccount?.email {
                        print("사용자 이메일 : \(email)")
                        UserDefaultManager.shared.email = email
                    } else {
                        print("사용자가 이메일 제공에 동의하지 않았습니다.")
                    }
                }
                
            }
        }
    }
    func presentToMain() {
        print("present to Main")
        
//        let nextVC = MainViewController()
//        self.navigationController?.pushViewController(nextVC, animated: true)
        //let nextVC = ToSViewController()
       // self.navigationController?.pushViewController(nextVC, animated: true)
       // sendAPIRequest(with: UserDefaultManager.shared.accessToken)
    }
    struct RequestBody: Encodable {
        let email: String
        let nickname: String?
    }
    
    func sendPostRequest(email: String, nickname: String?) {
        let url = "http://juinjang1227.com:8080/api/auth/kakao/login"
        
        let requestBody = RequestBody(email: email, nickname: nickname)
            
        AF.request(url, method: .post, parameters: requestBody, encoder: JSONParameterEncoder.default)
            .responseJSON { response in
                switch response.result {
                case .success(let value):
                    print("Success: \(value)")
                    print("닉네임 : \(nickname!)")
                    if let json = value as? [String: Any],
                       let result = json["result"] as? [String: Any],
                       let accessToken = result["accessToken"] as? String,
                       let refreshToken = result["refreshToken"] as? String {
                        print("Success: \(accessToken)")
                        UserDefaultManager.shared.accessToken = accessToken
                        print("Success: \(refreshToken)")
                        UserDefaultManager.shared.refreshToken = refreshToken
                        // accessToken을 사용하여 적절한 처리를 수행합니다.
                    } else {
                        print("Failed to parse accessToken")
                        // accessToken을 파싱하는 데 실패한 경우에 대한 처리를 수행합니다.
                    }
                    if nickname == nil {
                        let nextVC = ToSViewController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    } else {
                        let nextVC = MainViewController()
                        self.navigationController?.pushViewController(nextVC, animated: true)
                    }
                case .failure(let error):
                    print("Error: \(error)")
                    // 요청이 실패한 경우 여기에 적절한 처리를 추가하세요.
                }
        }
    }
}

