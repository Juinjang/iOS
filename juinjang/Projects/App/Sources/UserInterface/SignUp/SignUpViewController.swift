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
import AuthenticationServices
import RxSwift

final class SignUpViewController: BaseViewController {
    enum TransitionStyle {
        case present
        case push
    }
    
    private let currentTransitionStyle: TransitionStyle
    
    var disposeBag: DisposeBag = DisposeBag()
    lazy var juinjangLogoImage = UIImageView().then {
        $0.image = UIImage.SignUp.juinjangLogoGraphic
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var juinjangLogo = UIImageView().then {
        $0.image = UIImage.SignUp.juinjangLogo
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var kakaoLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage.SignUp.kakaoLogo, for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var appleLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage.SignUp.appleLogo, for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.addTarget(self, action: #selector(appleButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var guideLabel = UILabel().then {
        $0.text = "소셜 계정을 통해\n로그인 또는 회원가입을 진행해 주세요."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .gray450
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    private lazy var onboardingButton = TextButton(text: "서비스 체험하기", underline: true).then {
        $0.addTarget(self, action: #selector(onboardingButtonTapped(_:)), for: .touchUpInside)
    }
    
    private lazy var dismissButton = ImageButton(normalImage: .x24).then {
        $0.tintColor = .gray450
        $0.addTarget(self, action: #selector(dismissButtonTapped(_:)), for: .touchUpInside)
    }
    
    init(_ transitionStyle: TransitionStyle) {
        currentTransitionStyle = transitionStyle
        super.init()
        if transitionStyle == .present {
            self.modalPresentationStyle = .overFullScreen
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .mainWhite
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
         guideLabel,
         onboardingButton,
         dismissButton].forEach { view.addSubview($0) }
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
            $0.top.equalTo(juinjangLogo.snp.bottom).offset(view.frame.height * 0.10)
            $0.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.08)
            $0.centerX.equalToSuperview()
        }

        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(loginStackView.snp.bottom).offset(view.frame.height * 0.04)
        }
        
        if currentTransitionStyle == .push {
            dismissButton.removeFromSuperview()
            onboardingButton.snp.makeConstraints {
                $0.width.equalTo(90)
                $0.height.equalTo(19)
                $0.top.equalTo(guideLabel.snp.bottom).offset(32)
                $0.centerX.equalToSuperview()
            }
        } else {
            onboardingButton.removeFromSuperview()
            dismissButton.snp.makeConstraints {
                $0.size.equalTo(24)
                $0.top.equalTo(view.safeAreaLayoutGuide.snp.top)
                $0.right.equalToSuperview().offset(-24)
            }
        }
    }
    
    @objc func dismissButtonTapped(_ sender: UIButton) {
        dismiss(animated: true)
    }
    
    // 온보딩 분기처리
    @objc func onboardingButtonTapped(_ sender: UIButton) {
        UserDefaultManager.shared.isOnboarding = true
        UserDefaultManager.shared.nickname = "미래의 건물주"
        changeHome()
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
    @objc func appleButtonTapped(_ sender: UIButton) {
        let appleProvider = ASAuthorizationAppleIDProvider()
        let request = appleProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    
    }
    
    func getUserNickname() {
        JuinjangAPIManager.shared.fetchData(type: BaseResponse<UserInfoResult>.self, api: .profile) { response, error in
            if let error = error {
                print(error.localizedDescription)
                return
            }
            
            guard let response = response else { return }
            guard let result = response.result else { return }
            
            let nickname = result.nickname
            UserDefaultManager.shared.nickname = nickname ?? ""
            print("닉네임은 \(UserDefaultManager.shared.nickname)입니다.")
            
            if let profileImage = result.image, let imageUrl = URL(string: profileImage) {
                
                self.loadImage(from: imageUrl) { image in
                    if let image = image {
                        // 이미지 로드 성공
                        print("이미지 로드 성공")
                        UserDefaultManager.shared.profileImage = image
                    } else {
                        // 이미지 로드 실패
                        print("imageLoad Fail")
                    }
                }
            } else {
                UserDefaultManager.shared.profileImage = UIImage.Setting.profile
            }
            // 메인 화면으로 이동
            UserDefaultManager.shared.isOnboarding = false
            self.changeHome()
        }
    }
    private func loadImage(from url: URL, completion: @escaping (UIImage?) -> Void) {
        AF.request(url).responseData { response in
            switch response.result {
            case .success(let data):
                if let image = UIImage(data: data) {
                    completion(image)
                } else {
                    completion(nil)
                }
            case .failure(_):
                completion(nil)
            }
        }
    }
}

//카카오 로그인
extension SignUpViewController{
    private func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(oauthToken, error) in
            if let error = error {
                print("app\(error)")
            } else {
                print("loginWithKakaoTalk() success.")
                self.getUserInfo()
            }
        }
    }

    // 카카오톡 웹으로 로그인
    private func loginWithWeb() {
        UserApi.shared.loginWithKakaoAccount {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoAccount() success.")
                self.getUserInfo()
            }
        }
    }
    
    private func getUserInfo() {
        UserApi.shared.me { [weak self] (user, error) in
            guard let self else { return }
            if let error = error {
                print(error)
            } else {
                if let kakaoUser = user {
                    if let email = kakaoUser.kakaoAccount?.email,
                        let nickname = kakaoUser.kakaoAccount?.profile?.nickname {
                        print("사용자 이메일 : \(email)")
                        UserDefaultManager.shared.email = email
                        // 온보딩 분기처리
                        if (!UserDefaultManager.shared.isOnboarding) {
                            UserDefaultManager.shared.nickname = nickname
                        }
                        print("targetId: \(kakaoUser.id)")
                        if let userId = kakaoUser.id {
                            print("사용자 ID : \(userId)")
                            UserDefaultManager.shared.kakaoTargetId = userId
                            requestKakaoLogin(email: UserDefaultManager.shared.email,
                                              nickname: UserDefaultManager.shared.nickname,
                                              kakaoTargetId: userId)
                        } else {
                            print("사용자 ID를 가져올 수 없습니다.")
                        }
                    } else {
                        print("사용자가 이메일 제공에 동의하지 않았습니다.")
                    }
                }
            }
        }
    }
    
    struct RequestBody: Encodable {
        let email: String
        let nickname: String?
    }
    
    struct UserInfoResult: Codable {
        let nickname: String?
        let email: String
        let provider: String
        let image: String?
        
        init(from decoder: any Decoder) throws {
            let container = try decoder.container(keyedBy: CodingKeys.self)
            self.nickname = try container.decodeIfPresent(String.self, forKey: .nickname) ?? ""
            self.email = try container.decode(String.self, forKey: .email)
            self.provider = try container.decode(String.self, forKey: .provider)
            self.image = try container.decodeIfPresent(String.self, forKey: .image)
        }
    }        
    
    // 카카오 로그인
    private func requestKakaoLogin(email: String, nickname: String?, kakaoTargetId: Int64) {
        print(#function)
        let api = JuinjangAPI.kakaoLogin(kakaoTargetId: kakaoTargetId)
        let parameter: [String: Any] = [
            "email": email,
            "nickname": nickname ?? ""
        ]

        JuinjangAPIManager.shared.postData(
            type: BaseResponse<LoginResponse>.self,
            api: api,
            parameter: parameter
        ) { [weak self] response, error in

            guard let self else { return }
            if error == nil {
                guard let response else {
                    print("Kakao Login Response Is Empty")
                    return
                }
                UserDefaultManager.shared.isKakaoLogin = true
                
                guard let result = response.result else {
                    switch response.code {
                    case "MEMBER4001":
                        print("회원가입")
                        let nextVC = ToSViewController()
                        navigationController?.pushViewController(nextVC, animated: true)
                    case "MEMBER4003":
                        print("이미 애플로그인 했다미")
                        showAlert(message: "이미 Apple로 회원가입한 회원입니다")
                    case "MEMBER4011":
                        showAlert(message: "이미 KAKAO로 가입한 회원입니다")
                    default:
                        break
                    }
                    return
                }
                
                UserDefaultManager.shared.accessToken = result.accessToken
                UserDefaultManager.shared.refreshToken = result.refreshToken
                UserDefaultManager.shared.email = result.email
                UserDefaultManager.shared.agreeVersion = result.agreeVersion
                getUserNickname()
             
            } else {
                showAlert(message: "Kakao Login Request Error")
            }
        }
    }
    private func showAlert(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default, handler: nil)
        alertController.addAction(okAction)
        self.present(alertController, animated: true, completion: nil)
    }
}


//애플 로그인
extension SignUpViewController: ASAuthorizationControllerDelegate,ASAuthorizationControllerPresentationContextProviding {
    
    struct AppleLoginResponse: Codable {
        let isSuccess: Bool
        let code: String
        let message: String
        let result: Result
        
        struct Result: Codable {
            let accessToken: String
            let refreshToken: String
            let email: String
        }
    }
    private func performAppleSignInWithAlamofire(identityToken: String) {
        print(#function)
        
        let parameters: [String: Any] = [
            "identityToken": identityToken
        ]
        
        JuinjangAPIManager.shared.postData(type: BaseResponse<LoginResponse>.self, api: .appleLogin, parameter: parameters) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response else {
                    print("Apple Login Response Is Empty")
                    return
                }
                UserDefaultManager.shared.isKakaoLogin = false
                
                guard let result = response.result else {
                    switch response.code {
                    case "MEMBER4001":
                        print("회원가입")
                        let nextVC = ToSViewController()
                        navigationController?.pushViewController(nextVC, animated: true)
                        
                    case "MEMBER4006":
                        print("이미 카카오로그인 했다미")
                        showAlert(message: "이미 Kakao로 회원가입한 회원입니다.")
                        
                    case "MEMBER4011":
                        showAlert(message: "이미 가입된 이메일입니다.")
                        
                    default:
                        print("회원가입 실패 또는 다른 에러")
                    }
                    return
                }
            
                UserDefaultManager.shared.accessToken = result.accessToken
                UserDefaultManager.shared.refreshToken = result.refreshToken
                UserDefaultManager.shared.email = result.email
                UserDefaultManager.shared.agreeVersion = result.agreeVersion
                getUserNickname()
            } else {
                print("Apple Login Request Error")
            }
        }
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        if let authorizationCodeData = credential.authorizationCode,
           let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
            print("authorizationCode = \(authorizationCode)")
            UserDefaultManager.shared.appleAuthCode = authorizationCode
        } else {
            print("Authorization code is missing or invalid")
        }
        // MARK: - 이메일
        // 처음 애플 로그인 시 이메일은 credential.email 에 들어있다.
        if let email = credential.email {
            print("이메일 First : \(email)")
            if let tokenString = String(data: credential.identityToken ?? Data(), encoding: .utf8) {
                let email2 = Utils.decode(jwtToken: tokenString)["email"] as? String ?? ""
                print("identityToken : \(tokenString)")
                UserDefaultManager.shared.identityToken = tokenString
                performAppleSignInWithAlamofire(identityToken: tokenString)
            }
        }
        // 두번째부터는 credential.email은 nil이고, credential.identityToken에 들어있다.
        else {
            // credential.identityToken은 jwt로 되어있고, 해당 토큰을 decode 후 email에 접근해야한다.
            if let tokenString = String(data: credential.identityToken ?? Data(), encoding: .utf8) {
                let email2 = Utils.decode(jwtToken: tokenString)["email"] as? String ?? ""
                print("이메일 - \(email2)")
                print("identityToken : \(tokenString)")
                UserDefaultManager.shared.identityToken = tokenString
                performAppleSignInWithAlamofire(identityToken: tokenString)
            }
        }
        
        // MARK: - 이름
        // 처음 애플 로그인 시 이메일은 credential.fullName 에 들어있다.
        if let fullName = credential.fullName {
            print("이름 : \(fullName.familyName ?? "")\(fullName.givenName ?? "")")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패 \(error.localizedDescription)")
    }
    
    
    final class Utils {
        // MARK: - JWT decode
        static func decode(jwtToken jwt: String) -> [String: Any] {
            func base64UrlDecode(_ value: String) -> Data? {
                var base64 = value
                    .replacingOccurrences(of: "-", with: "+")
                    .replacingOccurrences(of: "_", with: "/")
                
                let length = Double(base64.lengthOfBytes(using: String.Encoding.utf8))
                let requiredLength = 4 * ceil(length / 4.0)
                let paddingLength = requiredLength - length
                if paddingLength > 0 {
                    let padding = "".padding(toLength: Int(paddingLength), withPad: "=", startingAt: 0)
                    base64 = base64 + padding
                }
                return Data(base64Encoded: base64, options: .ignoreUnknownCharacters)
            }
            
            func decodeJWTPart(_ value: String) -> [String: Any]? {
                guard let bodyData = base64UrlDecode(value),
                      let json = try? JSONSerialization.jsonObject(with: bodyData, options: []), let payload = json as? [String: Any] else {
                    return nil
                }
                return payload
            }
            let segments = jwt.components(separatedBy: ".")
            return decodeJWTPart(segments[1]) ?? [:]
        }
    }
}
