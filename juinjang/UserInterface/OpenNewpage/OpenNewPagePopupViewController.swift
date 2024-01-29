//
//  OpenNewPagePopupViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/27/24.
//

import UIKit
import Then

// 경고 팝업 메시지를 받아오기 위한 프로토콜
protocol WarningMessageDelegate: AnyObject {
    func getWarningMessage() -> String // 문자열을 반환
}

class OpenNewPagePopupViewController: UIViewController {
    
    weak var warningDelegate: WarningMessageDelegate?
    
    // 팝업 View
    lazy var popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    // 팝업 메시지 Label
    lazy var messageLabel = UILabel().then {
//        $0.text = "메인화면으로 돌아갈까요?\n입력한 정보는 저장되지 않습니다."
        $0.textColor = UIColor(red: 0.133, green: 0.133, blue: 0.133, alpha: 1)
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    // 아니요 Button
    lazy var cancelButton = UIButton().then {
        $0.setTitle("아니요", for: .normal)
        $0.setTitleColor(UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.925, green: 0.925, blue: 0.925, alpha: 1)
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    }
    
    // 돌아가기 Button
    lazy var goBackButton = UIButton().then {
        $0.setTitle("돌아가기", for: .normal)
        $0.setTitleColor(UIColor(red: 1, green: 1, blue: 1, alpha: 1), for: .normal)
        
        $0.backgroundColor = UIColor(red: 0.212, green: 0.212, blue: 0.212, alpha: 1)
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(confirmAction(_:)), for: .touchUpInside)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 흐리게 만듦
        setupWidgets()
        setupLayout()
        setWarningLabel()
     }

     func setWarningLabel() {
         // delegate를 통해 경고 메시지를 받아옴
         if let warningMessage = warningDelegate?.getWarningMessage() {
             messageLabel.text = warningMessage
         } else {
             messageLabel.text = "메인화면으로 돌아갈까요?\n입력한 정보는 저장되지 않습니다."
         }
     }

     // WarningMessageDelegate 프로토콜을 구현한 메서드
     func getWarningMessage() -> String {
         // 현재는 delegate로 받아올 메시지가 없음
         // 이 메서드를 호출하면서 경고 메시지를 설정하는 코드를 호출
         return ""
     }
    
    func setupWidgets() {
        view.addSubview(popupView)
        [messageLabel, cancelButton, goBackButton].forEach { popupView.addSubview($0)}
    }
    
    func setupLayout() {
        
        // 팝업 View
        popupView.snp.makeConstraints {
            $0.centerX.equalTo(view.snp.centerX)
            $0.centerY.equalTo(view.snp.centerY)
            $0.width.equalTo(342)
            $0.height.equalTo(234)
        }
        
        // 팝업 메시지
        messageLabel.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX)
            $0.top.equalTo(popupView.snp.top).offset(68)
        }
        
        // "아니요" Button
        cancelButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(-81)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(popupView.snp.leading).offset(12)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
        
        // "돌아가기" Button
        goBackButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(81.5)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(7)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func confirmAction(_ sender: UIButton) {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else {
            // window가 nil인 상태 혹은 not found
            return
        }
        guard let navigationController = window.rootViewController as? UINavigationController else {
            // 네비게이션 컨트롤러가 nil인 상태 혹은 not found
            return
        }
        navigationController.popToRootViewController(animated: true)
        
        // 현재 나타난 팝업창을 찾아서 닫기
        if let presentedViewController = navigationController.presentedViewController {
            presentedViewController.dismiss(animated: false, completion: nil)
        }
    }

}
