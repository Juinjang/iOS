//
//  SignUpViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/16.
//

import UIKit
import Then
import SnapKit

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
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var appleLoginButton = UIButton().then {
        $0.setBackgroundImage(UIImage(named: "apple-logo"), for: .normal)
        $0.contentMode = .scaleAspectFill
        $0.adjustsImageWhenHighlighted = false
        $0.addTarget(self, action: #selector(loginButtonTapped(_:)), for: .touchUpInside)
    }
    
    lazy var guideLabel = UILabel().then {
        $0.text = "소셜 계정을 통해\n로그인 또는 회원가입을 진행해 주세요."
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "darkGray")
        $0.font = UIFont(name: "Pretendard-Regular", size: 14)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage(named: "arrow-left")
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
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
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
        // -TODO: 온보딩 3번째 페이지로
    }
    
    @objc func loginButtonTapped(_ sender: UIButton) {
        // -TODO: 로그인 처리
    }
}
