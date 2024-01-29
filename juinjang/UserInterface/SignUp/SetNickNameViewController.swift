//
//  SetNickNameViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/16.
//

import UIKit
import Then
import SnapKit

class SetNickNameViewController: UIViewController {
    
    lazy var introLabel = UILabel().then {
        $0.text = "당신을 위한 노트를 준비했어요"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    lazy var guideLabel = UILabel().then {
        $0.text = "임장 노트에\n이름을 적어볼까요?"
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.asColor(targetString: "임장 노트", color: UIColor(named: "mainOrange"))
    }

    lazy var imjangNoteImage = UIImageView().then {
        $0.image = UIImage(named: "imjang-note")
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var textFieldContainerView = UIView().then {
        $0.backgroundColor = .white
        $0.layer.cornerRadius = 5
    }
    
    lazy var nickNameTextField = UITextField().then {
        $0.layer.cornerRadius = 3
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor(named: "mainOrange")?.cgColor
        $0.textAlignment = .center
        $0.textColor = UIColor(named: "normalText")
        $0.font = UIFont(name: "omyu pretty", size: 20)
        $0.attributedPlaceholder = NSAttributedString(
            string: "8자 이내",
            attributes: [
                .foregroundColor: UIColor(named: "gray1") as Any,
                .font: UIFont(name: "Pretendard-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
            ]
        )
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("입력 완료!", for: .normal)
        $0.setTitleColor(UIColor(named: "textWhite"), for: .normal)
        $0.backgroundColor = UIColor(named: "lightGray")
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .white
        self.navigationItem.title = "닉네임 정하기"
        super.viewDidLoad()
        nickNameTextField.delegate = self
        addSubViews()
        setupLayout()
    }

    
    func addSubViews() {
        [introLabel,
         guideLabel,
         imjangNoteImage,
         textFieldContainerView,
         nextButton].forEach { view.addSubview($0) }
        textFieldContainerView.addSubview(nickNameTextField)
    }
    
    func setupLayout() {
        // 소개 Label
        introLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(0.06 * view.bounds.width)
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(0.03 * view.bounds.height)
        }

        // 안내 Label
        guideLabel.snp.makeConstraints {
            $0.leading.equalTo(view.safeAreaLayoutGuide.snp.leading).offset(0.06 * view.bounds.width)
            $0.top.equalTo(introLabel.snp.bottom).offset(0.03 * view.bounds.height)
        }

        // 임장 노트 ImageView
        imjangNoteImage.snp.makeConstraints {
            $0.trailing.equalToSuperview()
            $0.top.equalTo(guideLabel.snp.bottom).offset(0.05 * view.bounds.height)
        }

        // 텍스트 필드 감싸는 View
        textFieldContainerView.snp.makeConstraints {
            $0.leading.equalTo(imjangNoteImage.snp.leading).offset(0.16 * view.bounds.width)
            $0.top.equalTo(imjangNoteImage.snp.top).offset(0.08 * view.bounds.height)
            $0.width.equalTo(149)
            $0.height.equalTo(51)
        }

//        textFieldContainerView.bringSubviewToFront(imjangNoteImage)

        // 닉네임 TextField
        nickNameTextField.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(135)
            $0.height.equalTo(37)
        }

        // 입력 완료 Button
        nextButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-0.03 * view.bounds.height)
            $0.width.equalTo(202)
            $0.height.equalTo(52)
        }
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        
        if let nickname = nickNameTextField.text, !nickname.isEmpty {
            let welcomeViewController = WelcomeViewController()
            welcomeViewController.userInfo = UserInfo(nickname: nickname)
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    func checkNextButtonActivation() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = UIColor(named: "textBlack")
    }
}

extension SetNickNameViewController: UITextFieldDelegate {
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        // 모든 조건을 검사하여 버튼 상태 변경
        checkNextButtonActivation()
    }
        
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }
        
        // 백 스페이스 실행 가능하도록
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if (isBackSpace == -92) {
                return true
            }
        }
        // 글자 수 제한
        guard textField.text!.count < 8 else { return false }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "" // 입력 시작 시 placeholder를 숨김
    }
}
