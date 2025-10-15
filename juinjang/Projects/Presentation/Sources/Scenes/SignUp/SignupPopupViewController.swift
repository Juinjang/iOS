//
//  SignupPopupViewController.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import UIKit
import Then

final class SignupPopupViewController: BaseViewController {
    weak var delegate: PopUpDelegate?
    
    // 팝업 View
    lazy var popupView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 10
    }
    
    // 팝업 메시지 Label
    lazy var messageLabel = UILabel().then {
        $0.text = "회원가입이 거의 끝났어요"
        $0.textColor = .gray600
        $0.font = UIFont(name: "Pretendard-Bold", size: 18)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    
    // 팝업 상세 메시지 Label
    lazy var messageDetailLabel = UILabel().then {
        $0.text = "잠시 뒤면 바로 주인장의\n다양한 서비스를 이용할 수 있어요.\n가입을 이어서 진행할까요?"
        $0.textColor = .gray600
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.numberOfLines = 3
        $0.setLineSpacing(spacing: 3)
        $0.textAlignment = .center
    }
    
    // 아니요 Button
    lazy var cancelButton = UIButton().then {
        $0.setTitle("아니요", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        
        $0.backgroundColor = .gray3
        $0.layer.cornerRadius = 8
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.titleLabel?.numberOfLines = 1
        $0.titleLabel?.adjustsFontSizeToFitWidth = true
        $0.titleLabel?.minimumScaleFactor = 0.5
        $0.titleLabel?.lineBreakMode = .byTruncatingTail
        $0.addTarget(self, action: #selector(cancelAction(_:)), for: .touchUpInside)
    }
    
    // 진행 Button
    lazy var continueButton = UIButton().then {
        $0.setTitle("진행할게요", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        
        $0.backgroundColor = .gray500
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
     }
    
    func setupWidgets() {
        view.addSubview(popupView)
        [messageLabel, messageDetailLabel, cancelButton, continueButton].forEach { popupView.addSubview($0)}
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
            $0.top.equalTo(popupView.snp.top).offset(35)
        }
        
        // 팝업 상세 메시지
        messageDetailLabel.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX)
            $0.top.equalTo(popupView.snp.top).offset(71)
        }
        
        // "아니요" Button
        cancelButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(-81)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(popupView.snp.leading).offset(12)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
        
        // "진행할게요" Button
        continueButton.snp.makeConstraints {
            $0.centerX.equalTo(popupView.snp.centerX).offset(81.5)
            $0.top.equalTo(popupView.snp.top).offset(169)
            $0.leading.equalTo(cancelButton.snp.trailing).offset(7)
            $0.bottom.equalTo(popupView.snp.bottom).offset(-13)
        }
    }
    
    @objc func cancelAction(_ sender: UIButton) {
//        let SignUpVC = SignUpViewController()
//        SignUpVC.modalPresentationStyle = .overCurrentContext
//        present(SignUpVC, animated: false, completion: nil)
        delegate?.didTapCancelButton()
        self.dismiss(animated: true, completion: nil)
    }
    
    @objc func confirmAction(_ sender: UIButton) {
        dismiss(animated: false, completion: nil)
    }
}
