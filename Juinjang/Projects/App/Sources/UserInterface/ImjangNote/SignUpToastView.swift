//
//  SignUpToastView.swift
//  App
//
//  Created by KimDongWoo on 12/14/25.
//

import UIKit
import Then
import SnapKit

final class SignUpToastView: BaseView {
    private let blurView = UIVisualEffectView(
        effect: UIBlurEffect(style: .systemThinMaterialDark)
    )

    private let overlayView = UIView()

    private let contentLabel = DSLabel(.body2).then {
        $0.fontColor = .mainWhite
        $0.text = "지금 가입하고 나도 사용해보기"
    }

    private lazy var signUpButton = TextButton(text: "시작하기").then {
        $0.addTarget(self, action: #selector(signUpButtonTapped(_:)), for: .touchUpInside)
    }
    
    var onTapSignUp: (() -> Void)?
    
    override func configureView() {
        super.configureView()

        // UIView 자체는 투명
        backgroundColor = .clear
        clipsToBounds = true
        roundCorners(cornerRadius: 4, corner: .all)

        // overlay 색상 (#222222, 90%)
        overlayView.backgroundColor = UIColor(
            red: 34/255,
            green: 34/255,
            blue: 34/255,
            alpha: 0.85
        )
    }

    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(blurView,
            overlayView,
            contentLabel,
            signUpButton)
    }

    override func configureLayout() {
        super.configureLayout()

        blurView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        overlayView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        contentLabel.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }

        signUpButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(16)
            $0.centerY.equalToSuperview()
        }
    }
    
    @objc private func signUpButtonTapped(_ sender: UIButton) {
        onTapSignUp?()
    }
}
