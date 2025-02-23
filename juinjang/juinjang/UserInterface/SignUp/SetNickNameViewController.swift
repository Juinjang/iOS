//
//  SetNickNameViewController.swift
//  juinjang
//
//  Created by 임수진 on 2024/01/16.
//

import UIKit
import Then
import SnapKit
import Alamofire

final class SetNickNameViewController: BaseViewController {
    
    lazy var introLabel = UILabel().then {
        $0.text = "당신을 위한 노트를 준비했어요"
        $0.numberOfLines = 2
        $0.textAlignment = .center
        $0.textColor = .gray600
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
    }
    
    lazy var guideLabel = UILabel().then {
        $0.text = "임장 노트에\n이름을 적어볼까요?"
        $0.numberOfLines = 2
        $0.textAlignment = .left
        $0.textColor = .gray600
        $0.font = UIFont(name: "Pretendard-Bold", size: 24)
        $0.asColor(targetString: "임장 노트", color: .main)
    }

    lazy var imjangNoteImage = UIImageView().then {
        $0.image = UIImage.SignUp.imjangNote
        $0.contentMode = .scaleAspectFill
    }
    
    lazy var textFieldContainerView = UIView().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 5
    }
    
    lazy var nickNameTextField = UITextField().then {
        $0.layer.cornerRadius = 3
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.main.cgColor
        $0.textAlignment = .center
        $0.textColor = .gray600
        $0.font = UIFont(name: "omyu pretty", size: 20)
        $0.attributedPlaceholder = NSAttributedString(
            string: "8자 이내",
            attributes: [
                .foregroundColor: UIColor.gray300,
                .font: UIFont(name: "Pretendard-Regular", size: 20) ?? UIFont.systemFont(ofSize: 20)
            ]
        )
    }
    
    lazy var nextButton = UIButton().then {
        $0.setTitle("입력 완료!", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.backgroundColor = .null
        $0.layer.cornerRadius = 8
        $0.isEnabled = false
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
    }
    
    override func viewDidLoad() {
        self.view.backgroundColor = .mainWhite
        super.viewDidLoad()
        nickNameTextField.delegate = self
        setNavigationBar()
        addSubViews()
        setupLayout()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func setNavigationBar() {
        self.navigationItem.title = "닉네임 정하기"
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.hidesBackButton = true
        let backButtonImage = UIImage.arrowLeft
        let backButton = UIBarButtonItem(image: backButtonImage, style: .plain,target: self, action: #selector(backButtonTapped))
        navigationItem.leftBarButtonItem = backButton
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
    
    func sendNickName() {
        print("sendNickName")

        let parameters: [String: Any] = [
            "nickname": UserDefaultManager.shared.nickname
        ]
        
        JuinjangAPIManager.shared.postData(type: BaseResponse<NicknameDto>.self, api: .saveNickname, parameter: parameters) { response, error in
            if error == nil {
                guard let response, let result = response.result else {
                    print("Save Nickname Response Is Empty")
                    return
                }
                print("\(result.nickname)")
            } else {
                print("Save Nickname Request Error")
            }
        }
    }
    
    @objc func backButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        // -TODO: 동일한 닉네임이 존재하지 않을 경우 다음 뷰 컨트롤러로 이동
        if let nickname = nickNameTextField.text, !nickname.isEmpty {
            let welcomeViewController = WelcomeViewController()
            welcomeViewController.userInfo = UserNickName(nickname: nickname)
            UserDefaultManager.shared.nickname = nickname
            navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
            navigationController?.pushViewController(welcomeViewController, animated: true)
        }
    }
    
    func checkNextButtonActivation() {
        nextButton.isEnabled = true
        nextButton.backgroundColor = .gray500
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
        guard text.count < 8 else { return false }
        
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.placeholder = "" // 입력 시작 시 placeholder를 숨김
    }
}
