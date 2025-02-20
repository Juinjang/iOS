//
//  TermsPopupViewController.swift
//  juinjang
//
//  Created by 박도연 on 12/20/24.
//

import UIKit

final class TermsPopupViewController: BaseViewController, TermPopupDelegate {
    func didAgreeToTerms() {
        isAgree = true
        button1.backgroundColor = .main100
        button1.layer.borderColor = UIColor.main.cgColor
        checkButton.image = UIImage(named: "check-after")
        button2.backgroundColor = .gray500
    }

    private let containerView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.text = "주인장 앱을 이용하려면\n업데이트 내용을 확인하고 동의해주세요"
        $0.textColor = .gray600
        $0.font = .pretendard(size: 20, weight: .semiBold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        let range = ($0.text! as NSString).range(of: "업데이트 내용을 확인하고 동의해주세요")
        attrString.addAttribute(.foregroundColor, value: UIColor.main, range: range)
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "아래는 더 나은 주인장 서비스를 제공하기 위해\n회원님의 정보를 활용하는 주요 방법들이에요."
        $0.font = .pretendard(size: 16, weight: .medium)
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
        $0.textColor = .gray600
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let readLabel = UILabel().then {
        $0.text = "천천히 살펴보신 후 동의 부탁드려요."
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray400
        $0.textAlignment = .left
        $0.numberOfLines = 0
    }
    
    private let button1 = UIButton().then {
        $0.backgroundColor = .mainWhite
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.null.cgColor
    }
    
    private var isAgree = false
    
    private let checkButton = UIImageView().then {
        $0.image = UIImage(named: "check-before")
    }
    
    private let termLabel = UILabel().then {
        $0.text = "(필수) 개인정보 수집 및 이용 동의"
        $0.textColor = .gray450
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.numberOfLines = 0
        
        let attrString = NSMutableAttributedString(string: $0.text!)
        let range = ($0.text! as NSString).range(of: "(필수)")
        attrString.addAttribute(.foregroundColor, value: UIColor.main, range: range)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
    }
    
    private let termsButton = UIButton().then {
        $0.setImage(UIImage(named: "term"), for: .normal)
    }
    
    private let button2 = UIButton().then {
        $0.setTitle("주인장 이용하러 가기", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.backgroundColor = .null
        $0.layer.cornerRadius = 10
    }
        
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        setupContainerView()
        setupUI()
        setupActions()
    }

    private func setupContainerView() {
        // 컨테이너 뷰 설정
        containerView.backgroundColor = .mainWhite
        containerView.layer.cornerRadius = 30
        containerView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner] // 위쪽만 둥글게
        containerView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(containerView)
        
        // 오토레이아웃 설정
        NSLayoutConstraint.activate([
            containerView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0),
            containerView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0),
            containerView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0),
            containerView.heightAnchor.constraint(equalToConstant: 397) // 원하는 높이 설정
        ])
    }
    
    private func setupUI() {
    
        [titleLabel, descriptionLabel, readLabel, button2, button1].forEach {
            containerView.addSubview($0)
        }
        button1.addSubview(termLabel)
        button1.addSubview(termsButton)
        button1.addSubview(checkButton)
        
        // 레이아웃 설정 (SnapKit 사용 예시)
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.left.equalToSuperview().offset(39)
            $0.width.equalTo(310)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.left.equalToSuperview().offset(39)
            $0.width.equalTo(290)
            $0.height.equalTo(47)
        }
        
        readLabel.snp.makeConstraints {
            $0.top.equalTo(descriptionLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(40)
            $0.height.equalTo(24)
        }
        
        button1.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(107)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(63)
        }
        
        checkButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(22)
            $0.left.equalToSuperview().offset(12)
            $0.width.equalTo(20)
        }
        
        termLabel.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(21)
            $0.left.equalToSuperview().offset(42)
            $0.width.equalTo(290)
        }
        
        termsButton.snp.makeConstraints {
            $0.top.equalToSuperview().offset(21)
            $0.right.equalToSuperview().inset(12)
            $0.width.equalTo(20)
        }
        
        button2.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(33)
            $0.left.right.equalToSuperview().inset(24)
            $0.height.equalTo(52)
        }
    }
    
    private func setupActions() {
        button1.addTarget(self, action: #selector(agreeTapped), for: .touchUpInside)
        button2.addTarget(self, action: #selector(gotoMain), for: .touchUpInside)
        termsButton.addTarget(self, action: #selector(termsButtonTapped), for: .touchUpInside)
    }
    
    private func updateAgreeVersion(version: String, completion: @escaping (Bool) -> Void) {
        let parameter = ["agreeVersion": version]
        JuinjangAPIManager.shared.postData(type: BaseResponse<String>.self, api: .updateAgreeVersion(version: version), parameter: parameter) { response, error in
            if error == nil {
                UserDefaultManager.shared.agreeVersion = version
                completion(true)
            } else {
                print("약관 동의 버전 업데이트 실패")
                completion(false)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func agreeTapped() {
        if isAgree {
            // 동의 -> 비동의로 변경
            button1.layer.borderColor = UIColor.null.cgColor
            button1.backgroundColor = .mainWhite
            checkButton.image = UIImage(named: "check-before")
            button2.backgroundColor = .null
        } else {
            // 비동의 색 -> 동의로 변경
            button1.backgroundColor = .main100
            button1.layer.borderColor = UIColor.main.cgColor
            checkButton.image = UIImage(named: "check-after")
            button2.backgroundColor = .gray500
        }
        isAgree.toggle()
    }
    
    @objc private func gotoMain() {
        guard isAgree else {
            print("Button2는 isAgree가 true일 때만 동작합니다.")
            return
        }
        
        let version = "1.1.0"
        updateAgreeVersion(version: version) { [weak self] success in
            if success {
                self?.dismiss(animated: true, completion: nil)
                print("동의했어요 \(UserDefaultManager.shared.agreeVersion)")
            }
        }
    }
    
    @objc private func termsButtonTapped() {
        let termView = NewTermsViewController()
        termView.delegate = self
        termView.modalPresentationStyle = .fullScreen
        present(termView, animated: false, completion: nil)
    }

}
