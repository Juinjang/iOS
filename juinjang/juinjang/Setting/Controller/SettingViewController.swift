//
//  SettingViewController.swift
//  Juinjang
//
//  Created by 박도연 on 1/9/24.
//

import UIKit
import Then
import SnapKit

class SettingViewController : UIViewController{
    static let id = "SettingViewController"
    
    //MARK: - 상단
    var settingLabel = UILabel().then {
        $0.text = "설정"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
    }
    var backButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setImage(UIImage(named:"Vector"), for: .normal)
        $0.addTarget(self, action: #selector(backBtnTap), for: .touchUpInside)
    }
    @objc
    func backBtnTap() {
        let vc = MainViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    //MARK: 프로필 사진, 닉네임
    var profileImageView = UIImageView().then {
        $0.image = UIImage(named:"프로필사진")
    }
    var editButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("수정", for: .normal)
        $0.setTitleColor(UIColor(named: "juinjang"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-Medium", size: 14)
    }
    
    var nicknameLabel = UILabel().then {
        $0.text = "닉네임"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "450")
    }
    var nickname = UILabel().then {
        $0.text = "땡땡"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
    }
    var nicknameTextField = UITextField().then {
        $0.backgroundColor = .white
        $0.returnKeyType = .done
        $0.placeholder = "8자 이내"
        $0.text = "땡땡"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
    }
    var nicknameWarnImageView = UIImageView().then {
        $0.image = UIImage(named:"warn")
    }
    var nicknameWarnLabel = UILabel().then {
        $0.text = "닉네임은 8자 이내로 입력해 주세요."
        $0.font = UIFont(name: "Pretendard-Medium", size: 12)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "juinjang")
    }
    
    var saveButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.layer.cornerRadius = 10
        $0.setTitle("변경", for: .normal)
        $0.backgroundColor = UIColor(named: "300")
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 14)
        $0.addTarget(self, action: #selector(tapChangeButton), for: .touchUpInside)
    }
    @objc
    func tapChangeButton(_ sender: Any) {
        switch saveButton.titleLabel?.text {
        case "변경":
            saveButton.setTitle("저장", for: .normal)
            saveButton.backgroundColor = UIColor(named: "juinjang")
            view.addSubview(nicknameTextField)
            nicknameTextField.delegate = self
            view.addSubview(line1)
            nicknameTextField.snp.makeConstraints{
             $0.top.equalTo(nicknameLabel.snp.bottom).offset(8)
             $0.left.equalToSuperview().offset(24)
             $0.width.equalTo(264)
             $0.height.equalTo(23)
            }
            line1.snp.makeConstraints{
                $0.top.equalTo(nicknameTextField.snp.bottom).offset(3)
                $0.left.equalToSuperview().offset(24)
                $0.width.equalTo(264)
                $0.height.equalTo(1)
            }
        default:
            saveButton.setTitle("변경", for: .normal)
            saveButton.backgroundColor = UIColor(named: "300")
            nicknameTextField.removeFromSuperview()
            line1.removeFromSuperview()
            nicknameWarnLabel.removeFromSuperview()
            nicknameWarnImageView.removeFromSuperview()
            nickname.text = nicknameTextField.text
        }
    }
    var line1 = UIView().then {
        $0.backgroundColor = UIColor(named: "stroke")
    }
    
    //MARK: 로그인 정보
    var logInfoLabel = UILabel().then {
        $0.text = "로그인 정보"
        $0.font = UIFont(name: "Pretendard-Medium", size: 14)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "450")
    }
    
    var logImageView = UIImageView().then {
        $0.image = UIImage(named:"KAKAO")
    }
    
    var logInfoMailLabel = UILabel().then {
        $0.text = "juinjang@daum.net"
        $0.font = UIFont(name: "Pretendard-Medium", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
    }
    
    var line2 = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    
    //MARK: 이용약관, 자주 묻는 질문
    var useButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(click1), for: .touchUpInside)
    }
    
    @objc
    func click1(_ sender: Any) {
        let vc = UseViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    var useImageView = UIImageView().then {
        $0.image = UIImage(named:"이용약관")
    }
    
    var useLabel = UILabel().then {
        $0.text = "이용약관"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
    }
    
    var qnaButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(click2), for: .touchUpInside)
    }
    
    @objc
    func click2(_ sender: Any) {
        let vc = QnAViewController()
        self.navigationController?.pushViewController(vc, animated: false)
    }
    
    var qnaImageView = UIImageView().then {
        $0.image = UIImage(named:"Q&A")
    }
    
    var qnaLabel = UILabel().then {
        $0.text = "자주 묻는 질문"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "500")
    }
    
    var line3 = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    
    //MARK: 로그아웃, 계정삭제
    var logoutButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("로그아웃", for: .normal)
        $0.setTitleColor(UIColor(named: "juinjang"), for: .normal)
        $0.titleLabel?.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.addTarget(self, action: #selector(logoutButtonTap), for: .touchUpInside)
    }
    @objc private func logoutButtonTap() {
        let popupViewController = LogoutPopupViewController(name: "땡땡", email: "juinjang@daum.net", ment: "계정에서 로그아웃할까요?")
        popupViewController.modalPresentationStyle = .overFullScreen
        self.present(popupViewController, animated: false)
    }
    
    var line4 = UIView().then {
        $0.backgroundColor = UIColor(named: "100")
    }
    var backgroundView = UIView().then{
        $0.backgroundColor = .black.withAlphaComponent(0.6)
    }
    var accountDeleteButton = UIButton().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.addTarget(self, action: #selector(click4), for: .touchUpInside)
    }
    @objc
    func click4(_ sender: Any) {
        let vc = AccountDeleteViewController()
        vc.modalPresentationStyle = .overFullScreen
        self.present(vc, animated: true)
    }
    
    var accountDeleteLabel = UILabel().then {
        $0.text = "계정 삭제하기"
        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.textColor = UIColor(named: "450")
    }
    
    //MARK: - 함수
    func setConstraint() {
        settingLabel.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(12.16)
            $0.centerX.equalToSuperview()
        }
        
        backButton.snp.makeConstraints{
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(11.16)
            $0.right.equalToSuperview().inset(23.5)
            $0.width.height.equalTo(22)
        }
        
        profileImageView.snp.makeConstraints{
            $0.top.equalTo(settingLabel.snp.bottom).offset(40)
            $0.centerX.equalToSuperview()
            $0.width.height.equalTo(66)
        }
        
        editButton.snp.makeConstraints{
            $0.top.equalTo(profileImageView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        nicknameLabel.snp.makeConstraints{
            $0.top.equalTo(editButton.snp.bottom).offset(28)
            $0.left.equalToSuperview().offset(24)
        }
        
        nickname.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(24)
        }
        
        saveButton.snp.makeConstraints{
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(5)
            $0.right.equalToSuperview().inset(21)
            $0.height.equalTo(29)
            $0.width.equalTo(64)
        }
        
        logInfoLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(79)
            $0.left.equalToSuperview().offset(24)
        }
        
        logImageView.snp.makeConstraints{
            $0.top.equalTo(logInfoLabel.snp.bottom).offset(10)
            $0.left.equalToSuperview().offset(24)
        }
        
        logInfoMailLabel.snp.makeConstraints{
            $0.top.equalTo(logInfoLabel.snp.bottom).offset(8)
            $0.left.equalTo(logImageView.snp.right).offset(8)
        }
        
        line2.snp.makeConstraints {
            $0.top.equalTo(logInfoMailLabel.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        useButton.snp.makeConstraints {
            $0.top.equalTo(line2.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        useImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        
        useLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalTo(useImageView.snp.right).offset(8)
        }
        
        qnaButton.snp.makeConstraints {
            $0.top.equalTo(useButton.snp.bottom)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        
        qnaImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(24)
        }
        
        qnaLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.left.equalTo(qnaImageView.snp.right).offset(8)
        }
        
        line3.snp.makeConstraints {
            $0.top.equalTo(qnaImageView.snp.bottom).offset(28)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        logoutButton.snp.makeConstraints {
            $0.top.equalTo(line3.snp.bottom).offset(25)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(23)
        }
        
        line4.snp.makeConstraints {
            $0.top.equalTo(logoutButton.snp.bottom).offset(25)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(4)
        }
        
        accountDeleteButton.snp.makeConstraints {
            $0.top.equalTo(line4.snp.bottom).offset(10)
            $0.left.right.equalToSuperview()
            $0.height.equalTo(60)
        }
        accountDeleteLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(15)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(23)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(settingLabel)
        view.addSubview(backButton)
        view.addSubview(profileImageView)
        view.addSubview(editButton)
        view.addSubview(nicknameLabel)
        view.addSubview(nickname)
        view.addSubview(saveButton)
        view.addSubview(line1)
        view.addSubview(logInfoLabel)
        view.addSubview(logImageView)
        view.addSubview(logInfoMailLabel)
        view.addSubview(line2)
        
        view.addSubview(useButton)
        useButton.addSubview(useImageView)
        useButton.addSubview(useLabel)
        view.addSubview(qnaButton)
        qnaButton.addSubview(qnaImageView)
        qnaButton.addSubview(qnaLabel)
        view.addSubview(line3)
        
        view.addSubview(logoutButton)
        view.addSubview(line4)
        
        view.addSubview(accountDeleteButton)
        accountDeleteButton.addSubview(accountDeleteLabel)
        
        view.backgroundColor = .white
        
        setConstraint()
    }
}

extension SettingViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard nicknameTextField.text!.count < 8
        else {
            view.addSubview(nicknameWarnImageView)
            view.addSubview(nicknameWarnLabel)
            nicknameWarnImageView.snp.makeConstraints{
                $0.top.equalTo(line1.snp.bottom).offset(9)
                $0.left.equalToSuperview().offset(24)
                $0.height.equalTo(16)
            }
            nicknameWarnLabel.snp.makeConstraints{
                $0.top.equalTo(line1.snp.bottom).offset(9)
                $0.left.equalTo(nicknameWarnImageView.snp.right).offset(3)
            }
            return false
        }
        nicknameWarnLabel.removeFromSuperview()
        nicknameWarnImageView.removeFromSuperview()
        return true
    }
}