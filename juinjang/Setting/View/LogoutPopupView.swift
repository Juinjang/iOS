//
//  LogoutPopupView.swift
//  Juinjang
//
//  Created by 박도연 on 1/16/24.
//
import UIKit
import SnapKit
import Then

class LogoutPopupView: UIView {
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    private let nameLabel = UILabel().then {
        $0.textColor = UIColor(named: "juinjang")
        $0.font = UIFont(name: "Pretendard-Medium", size: 18)
        $0.numberOfLines = 0
    }
    private let emailLabel = UILabel().then {
        $0.textColor = UIColor(named: "450")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.numberOfLines = 0
    }
    private let mentLabel = UILabel().then {
        $0.textColor = UIColor(named: "600")
        $0.font = UIFont(name: "Pretendard-Medium", size: 18)
        $0.numberOfLines = 0
    }
    private let leftButton = UIButton().then {
        $0.setTitleColor(UIColor(named: "500"), for: .normal)
        $0.backgroundColor = UIColor(named: "ECECEC")
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(LogoutPopupViewController.no(_:)), for: .touchUpInside)
    }
    
    private let rightButton = UIButton().then {
        $0.setTitleColor(.white, for: .normal)
        $0.backgroundColor = UIColor(named: "500")
        $0.layer.cornerRadius = 10
    }
  
    init(name: String, email: String, ment: String, leftButtonTitle: String = "아니요", rightButtonTitle: String = "예") {
        self.nameLabel.text = name
        self.emailLabel.text = email
        self.mentLabel.text = ment
        self.leftButton.setTitle(leftButtonTitle, for: .normal)
        self.rightButton.setTitle(rightButtonTitle, for: .normal)
        super.init(frame: .zero)
    
        self.backgroundColor = .black.withAlphaComponent(0.6)
        self.addSubview(self.popupView)
        [self.bodyStackView, self.leftButton, self.rightButton]
            .forEach(self.popupView.addSubview(_:))
        [self.nameLabel, self.emailLabel, self.mentLabel]
            .forEach(self.bodyStackView.addSubview(_:))
    
        self.popupView.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(234)
            $0.centerY.equalToSuperview()
        }
        self.bodyStackView.snp.makeConstraints {
            $0.left.right.top.equalToSuperview()
            $0.height.equalTo(130)
        }
        self.nameLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(35)
            $0.centerX.equalToSuperview()
        }
        self.emailLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(5)
            $0.centerX.equalToSuperview()
        }
        self.mentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
        self.leftButton.snp.makeConstraints {
            $0.top.equalTo(bodyStackView.snp.bottom).offset(39)
            $0.left.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(13)
            $0.width.equalTo(156)
            $0.height.equalTo(52)
        }
        self.rightButton.snp.makeConstraints {
            $0.top.equalTo(bodyStackView.snp.bottom).offset(39)
            $0.left.equalTo(leftButton.snp.right).offset(7)
            $0.right.equalToSuperview().inset(13)
            $0.bottom.equalToSuperview().inset(13)
            $0.width.equalTo(156)
            $0.height.equalTo(52)
        }
    }
    required init?(coder: NSCoder) { fatalError() }
}
