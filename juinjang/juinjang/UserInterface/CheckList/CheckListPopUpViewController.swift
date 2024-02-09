//
//  CheckListPopUpViewController.swift
//  juinjang
//
//  Created by 임수진 on 2/7/24.
//

import UIKit

// 경고 팝업 메시지를 받아오기 위한 프로토콜
protocol MoveWarningMessageDelegate: AnyObject {
    func getWarningMessage() -> String // 문자열을 반환
}

class CheckListPopUpViewController: UIViewController {
    
    weak var moveWarningDelegate: MoveWarningMessageDelegate?

    // 팝업 View
    lazy var popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
    }
    
    // 팝업 메시지 Label
    lazy var messageLabel = UILabel().then {
        $0.text = "기록룸으로 이동할까요?\n저장하지 않은 수정사항은 사라집니다."
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
//        $0.setLineSpacing(spacing: 3)
        $0.textAlignment = .center
        $0.numberOfLines = 2
    }
    
    // 아니요 Button
    lazy var cancelButton = UIButton().then {
        $0.setTitle("아니요", for: .normal)
        $0.setTitleColor(UIColor(named: "textBlack"), for: .normal)
        
        $0.backgroundColor = UIColor(named: "gray3")
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    }
    
    // 이동하기 Button
    lazy var moveButton = UIButton().then {
        $0.setTitle("이동하기", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        
        $0.backgroundColor = UIColor(named: "textBlack")
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(moveAction(_:)), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.black.withAlphaComponent(0.7) // 흐리게 만듦
        setupWidgets()
        setupLayout()
     }
    
    func setWarningLabel() {
        // delegate를 통해 경고 메시지를 받아옴
        if let warningMessage = moveWarningDelegate?.getWarningMessage() {
            messageLabel.text = warningMessage
        } else {
            // 기본
            messageLabel.text = "기록룸으로 이동할까요?\n저장하지 않은 수정사항은 사라집니다."
        }
    }

    // moveWarningMessageDelegate 프로토콜을 구현한 메서드
    func getWarningMessage() -> String {
        // 현재는 delegate로 받아올 메시지가 없음
        // 이 메서드를 호출하면서 경고 메시지를 설정하는 코드를 호출
        return ""
    }
    
    func setupWidgets() {
        view.addSubview(popupView)
        [messageLabel, cancelButton, moveButton].forEach { popupView.addSubview($0)}
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
            $0.bottom.equalTo(popupView.snp.bottom).offset(-120)
        }
        
        // "아니요" Button
        cancelButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(-81)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(popupView.snp.leading).offset(12)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
        
        // "이동하기" Button
        moveButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(81.5)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(7)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
    }
    
    @objc func cancelAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
    
    @objc func moveAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
