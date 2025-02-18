//
//  NoMaemullPopupView.swift
//  juinjang
//
//  Created by 박도연 on 1/31/24.
//
import UIKit
import SnapKit
import Then

final class NoMaemullPopupView: UIView {
    private let popupView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 10
        $0.clipsToBounds = true
    }
    private let bodyStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let mentLabel = UILabel().then {
        $0.textColor = UIColor(named: "600")
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.numberOfLines = 0
        $0.textAlignment = .center
    }
    let Button = UIButton().then {
        $0.setTitleColor(UIColor.white, for: .normal)
        $0.backgroundColor = UIColor(named: "500")
        $0.layer.cornerRadius = 10
        $0.addTarget(self, action: #selector(NoMaemullPopupViewController.btnTap(_:)) , for: .touchUpInside)
    }
    
  
    init(ment: String, ButtonTitle: String = "확인했어요") {
        
        self.mentLabel.text = ment
        self.Button.setTitle(ButtonTitle, for: .normal)
        self.Button.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        super.init(frame: .zero)
    
        self.backgroundColor = .black.withAlphaComponent(0.6)
        self.addSubview(self.popupView)
        [self.bodyStackView, self.Button]
            .forEach(self.popupView.addSubview(_:))
        [self.mentLabel]
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
        
        self.mentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(68)
        }
        self.Button.snp.makeConstraints {
            $0.top.equalTo(bodyStackView.snp.bottom).offset(39)
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalToSuperview().inset(13)
            $0.height.equalTo(52)
        }
        
    }
    required init?(coder: NSCoder) { fatalError() }
}
