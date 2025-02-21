//
//  AccountDeleteFinalViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/19/24.
//

import UIKit
import Then
import SnapKit
import Alamofire
import AuthenticationServices

final class AccountDeleteFinalViewController: BaseViewController {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    
    var accountDeleteFinalView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 30
    }
    
    var logoImageView = UIImageView().then {
        $0.image = UIImage(named:"deleteLogo")
    }
    
    var bigMent = UILabel().then {
        $0.text = "더 나은 주인장이 되도록 \n노력할게요"
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Pretendard-Bold", size: 20)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray600
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 3.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    var smallMent = UILabel().then {
        $0.text = "불편했던 점을 남겨주시면 주인장 팀에 큰 도움이 됩니다. \n다음에 또 만나요!"
        $0.numberOfLines = 0
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = .gray500
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 5.0
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    
    let buttonList = ["더 이상 쓸 일이 없어요", "앱 사용법을 모르겠어요", "임장에 도움이 되지 않아요", "앱이 정상적으로 작동하지 않아요", "보안이 걱정돼요", "다른 서비스가 더 좋아요"]
    
    let textMapping : [String: String] = ["더 이상 쓸 일이 없어요": "NOT_USE", "앱 사용법을 모르겠어요": "CANNOT_USE", "임장에 도움이 되지 않아요": "NOT_HELP", "앱이 정상적으로 작동하지 않아요": "CANNOT_FUNCTION", "보안이 걱정돼요": "CONCERN_SECURITY", "다른 서비스가 더 좋아요": "OTHER_SERVICE"]
    
    var btnArry : [UIButton] = []
    var selectedTexts: [String] = []
    
    var noButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("취소하고 돌아갈래요", for: .normal)
        $0.backgroundColor = .gray600
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.cornerRadius = 10
    }
    var yesButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.backgroundColor = .main
        $0.setTitle("계정 삭제하기", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.layer.cornerRadius = 10
    }
    
    func setConstraint() {
        accountDeleteFinalView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide)
            $0.left.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        logoImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(33)
            $0.left.equalToSuperview().offset(24)
            $0.width.equalTo(49)
            $0.height.equalTo(51)
        }
        bigMent.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(31)
            $0.left.equalToSuperview().offset(24)
        }
        smallMent.snp.makeConstraints{
            $0.top.equalTo(logoImageView.snp.bottom).offset(114)
            $0.left.equalToSuperview().offset(24)
        }
        noButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(93)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
        yesButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
        
    }
    
    @objc
    private func btnSelected(_ sender: UIButton) {
        sender.isSelected.toggle()
        if sender.isSelected {
            sender.backgroundColor = .main200
            sender.layer.borderWidth = 1.5
            sender.layer.borderColor = UIColor.mainStroke.cgColor
            sender.setTitleColor(.main, for: .normal)
            
            // 버튼의 텍스트를 selectedTexts 배열에 추가
            if let title = sender.title(for: .normal) {
                selectedTexts.append(title)
            }
            
            print(selectedTexts)
        } else {
            sender.backgroundColor = .gray100
            sender.layer.borderWidth = 0
            sender.layer.borderColor = .none
            sender.setTitleColor(.gray450, for: .normal)
            
            // 버튼의 텍스트를 selectedTexts 배열에서 제거
            if let title = sender.title(for: .normal), let index = selectedTexts.firstIndex(of: title) {
                selectedTexts.remove(at: index)
            }
        }
    }
    @objc private  func no(_ sender: Any) {
        dismiss(animated: false, completion: nil)
    }
    @objc private  func yes(_ sender: Any) {
        if UserDefaultManager.shared.isKakaoLogin {
            withdrawKakaoAccount(accessToken: UserDefaultManager.shared.accessToken, kakaoTargetId: UserDefaultManager.shared.kakaoTargetId)
        } else {
            let appleProvider = ASAuthorizationAppleIDProvider()
            let request = appleProvider.createRequest()
            request.requestedScopes = [.fullName, .email]
            
            let controller = ASAuthorizationController(authorizationRequests: [request])
            controller.delegate = self
            controller.presentationContextProvider = self
            controller.performRequests()
        }
        
    }
    
    // 카카오톡 탈퇴 API를 호출하는 함수
    private func withdrawKakaoAccount(accessToken: String, kakaoTargetId: Int64) {
        
        let mappedTexts = selectedTexts.compactMap { textMapping[$0] }
        print("탈퇴 사유 : \(mappedTexts)")
        
        let requestBody: [String: Any] = ["withdrawReason": mappedTexts]
        
        JuinjangAPIManager.shared.postData(type: BaseResponseString.self, api: .withdrawKakao(targetId: kakaoTargetId), parameter: requestBody) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response else {
                    print("withdrawKakaoAccount response Empty")
                    return
                }
                print("withdraw Kakao Result: \(response.result)")
                UserDefaultManager.shared.removeUserInfo()
                changeLoginVC()
            } else {
                guard let error = error else { return }
                print("withdrawKakaoAccount Error", error)
            }
        }
    }
    
    // apple 탈퇴 API를 호출하는 함수
    private func withdrawAppleAccount(accessToken: String, xAppleCode: String) {
        
        let mappedTexts = selectedTexts.compactMap { textMapping[$0] }
        
        let requestBody: [String: Any] = ["withdrawReason": mappedTexts]

        print("access : \(accessToken)")
        print("apple 토큰 : \(xAppleCode)")
        
        JuinjangAPIManager.shared.postData(type: BaseResponseString.self, api: .withdrawApple(xAppleCode: xAppleCode), parameter: requestBody) { [weak self] response, error in
            guard let self else { return }
            if error == nil {
                guard let response else {
                    print("withdrawAppleAccount response Empty")
                    return
                }
                print("withdraw Apple Result: \(response.result)")
                UserDefaultManager.shared.removeUserInfo()
                changeLoginVC()
            } else {
                guard let error = error else { return }
                print("withdrawAppleAccount Error", error)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(accountDeleteFinalView)
        accountDeleteFinalView.addSubview(logoImageView)
        accountDeleteFinalView.addSubview(bigMent)
        accountDeleteFinalView.addSubview(smallMent)
        
        for i in 0...5 {
            let selectedbutton = UIButton().then {
                $0.backgroundColor = .gray100
                $0.layer.cornerRadius = 10
                //$0.isUserInteractionEnabled = true
                $0.setTitle(buttonList[i], for: .normal)
                $0.titleEdgeInsets = UIEdgeInsets(top: 0,left: 16,bottom: 0,right: 0)
                $0.setTitleColor(.gray450, for: .normal)
                $0.contentHorizontalAlignment = .left
                $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 16)
                $0.addTarget(self, action: #selector(btnSelected), for: .touchUpInside)
            }
            
            accountDeleteFinalView.addSubview(selectedbutton)
            selectedbutton.snp.makeConstraints {
                $0.top.equalTo(smallMent.snp.bottom).offset(20+i*62)
                $0.left.right.equalToSuperview().inset(24)
                $0.height.equalTo(54)
            }
            btnArry.append(selectedbutton)
        }
    
        accountDeleteFinalView.addSubview(noButton)
        noButton.addTarget(self, action: #selector(no), for: .touchUpInside)
        accountDeleteFinalView.addSubview(yesButton)
        yesButton.addTarget(self, action: #selector(yes), for: .touchUpInside)
        setConstraint()
    }
}

extension AccountDeleteFinalViewController : ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        if let authorizationCodeData = credential.authorizationCode,
           let authorizationCode = String(data: authorizationCodeData, encoding: .utf8) {
            print("authorizationCode = \(authorizationCode)")
            UserDefaultManager.shared.appleAuthCode = authorizationCode
            withdrawAppleAccount(accessToken: UserDefaultManager.shared.accessToken, xAppleCode: UserDefaultManager.shared.appleAuthCode)
        } else {
            print("Authorization code is missing or invalid")
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("애플 로그인 실패 \(error.localizedDescription)")
    }
}
