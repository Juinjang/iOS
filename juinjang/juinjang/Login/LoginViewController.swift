
import UIKit
import SnapKit
import Then

import KakaoSDKCommon
import KakaoSDKAuth
import KakaoSDKUser

class LoginViewController: UIViewController {
    
    let logoImageView = UIImageView().then {
        $0.image = UIImage(named: "Logo")
    }
    let lableLogoImageView = UIImageView().then {
        $0.image = UIImage(named: "labelLogo")
    }
    let kakaoButton = UIButton().then {
        $0.setImage(UIImage(named: "kakaoLogo"), for: .normal)
    }
    var loginLabel = UILabel().then {
        $0.text = "소셜 계정을 통해\n로그인 또는 회원가입을 진행해 주세요."
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "300")
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    func setConstraint() {
        logoImageView.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(156.16)
            $0.centerX.equalToSuperview()
        }
        lableLogoImageView.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(34.66)
            $0.centerX.equalToSuperview()
        }
        kakaoButton.snp.makeConstraints{
            $0.top.equalTo(lableLogoImageView.snp.bottom).offset(173)
            $0.centerX.equalToSuperview()
        }
        loginLabel.snp.makeConstraints{
            $0.top.equalTo(kakaoButton.snp.bottom).offset(32)
            $0.centerX.equalToSuperview()
        }
    }
    
    // 카카오 로그인 버튼 클릭 시
    /*@objc
    func kakaoSignInButtonPress() {
        // 카카오톡 설치 여부 확인
        if UserApi.isKakaoTalkLoginAvailable() {
            // 카카오톡 로그인. api 호출 결과를 클로저로 전달.
            loginWithApp()
        } else {
            // 만약, 카카오톡이 깔려있지 않을 경우에는 웹 브라우저로 카카오 로그인함.
            loginWithWeb()
        }
    }*/
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        view.addSubview(logoImageView)
        view.addSubview(lableLogoImageView)
        view.addSubview(kakaoButton)
        //kakaoButton.addTarget(self, action: #selector(kakaoSignInButtonPress), for: .touchUpInside)
        view.addSubview(loginLabel)
        
        setConstraint()
    }
    
}

// MARK: - Kakao Login Extensions

/*extension LoginViewController {
    
    // 카카오톡 앱으로 로그인
    func loginWithApp() {
        UserApi.shared.loginWithKakaoTalk {(_, error) in
            if let error = error {
                print(error)
            } else {
                print("loginWithKakaoTalk() success.")
                
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.presentToMain()
                    }
                }
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
                
                UserApi.shared.me {(user, error) in
                    if let error = error {
                        print(error)
                    } else {
                        self.presentToMain()
                    }
                }
            }
        }
    }
    
    // 화면 전환 함수
    func presentToMain() {
        let nextVC = storyboard?.instantiateViewController(withIdentifier: "TabBarVC") as! UITabBarController
        nextVC.modalPresentationStyle = .fullScreen
        self.present(nextVC, animated: true, completion: nil)
    }
}
*/
