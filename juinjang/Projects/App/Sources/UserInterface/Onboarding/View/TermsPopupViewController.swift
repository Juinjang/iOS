//
//  TermsPopupViewController.swift
//  juinjang
//
//  Created by 박도연 on 12/20/24.
//

import UIKit
import Then
import SafariServices

final class TermsPopupViewController: BaseViewController, TermPopupDelegate {
    enum NavigationType {
        case link(String)
        case view(UIViewController)
    }
    
    func didAgreeToTerms() {
        isAgree = true
        button1.backgroundColor = .main100
        button1.layer.borderColor = UIColor.main.cgColor
        checkButton.image = UIImage.checkAfter
        button2.backgroundColor = .gray500
    }

    private let containerView = UIView()
    
    private let titleLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .pretendard(size: 20, weight: .semiBold)
        $0.textAlignment = .left
        $0.numberOfLines = 0
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
        $0.image = UIImage.checkBefore
    }
    
    private let termLabel = UILabel().then {
        $0.textColor = .gray450
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.numberOfLines = 0
    }
    
    private let termsButton = UIButton().then {
        $0.setImage(UIImage.term, for: .normal)
    }
    
    private let button2 = UIButton().then {
        $0.setTitle("주인장 이용하러 가기", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.backgroundColor = .null
        $0.layer.cornerRadius = 10
    }
    
    private let navigationType: NavigationType
    
    init(isAgree: Bool = false,
         title: String,
         titleMain: String,
         term: String,
         navigationType: NavigationType) {
        self.isAgree = isAgree
        self.navigationType = navigationType
        super.init()
        titleLabel.attributedText = styledText(title, highlight: titleMain)
        termLabel.attributedText = styledText(term, highlight: "(필수)")
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.5)
        setupContainerView()
        setupUI()
        setupActions()
    }
    
    private func styledText(_ text: String, highlight: String) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: text)
        let range = (text as NSString).range(of: highlight)
        attr.addAttribute(.foregroundColor, value: UIColor.main, range: range)
        
        let style = NSMutableParagraphStyle()
        style.lineHeightMultiple = 1.22
        attr.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attr.length))
        return attr
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
            checkButton.image = UIImage.checkBefore
            button2.backgroundColor = .null
        } else {
            // 비동의 색 -> 동의로 변경
            button1.backgroundColor = .main100
            button1.layer.borderColor = UIColor.main.cgColor
            checkButton.image = UIImage.checkAfter
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
        switch navigationType {
        case .link(let url):
            if let url = URL(string: url) {
                let safariVC = SFSafariViewController(url: url)
                present(safariVC, animated: true, completion: nil)
            }
        case .view(let viewController):
            if let termsVC = viewController as? NewTermsViewController {
                termsVC.delegate = self
                termsVC.modalPresentationStyle = .fullScreen
                termsVC.modalTransitionStyle = .crossDissolve
                present(termsVC, animated: true)
            } else {
                present(viewController, animated: true)
            }
        }
    }

}
