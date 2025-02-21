//
//  ToS3ViewController.swift
//  juinjang
//
//  Created by 임수진 on 12/16/24.
//

import UIKit

final class ToS3ViewController: BaseViewController {
    
    let scrollView = UIScrollView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 10
        $0.layer.borderWidth = 1
        $0.layer.borderColor = UIColor.stroke.cgColor
    }
    
    let contentView = UIView()
    
    lazy var contentLabel = UILabel().then {
        $0.textColor = .gray600
        $0.text = "마케팅 활용동의"
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 16, weight: .semiBold)
    }
    
    private let contentLabel1 = UILabel().then {
        $0.text = "1. 마케팅 활용 동의(선택)\n주인장은 개인정보 보호법 제 22조 제4항과 제39조의 3에 따라 사용자의 광고성 정보 수신과 이에 따른 개인정보 처리에 대한 동의를 받고 있습니다. 약관에 동의하지 않으셔도 주인장의 모든 서비스를 이용하실 수 있습니다. 다만, 이벤트, 혜택 등의 제한이 있을 수 있습니다."
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray500
    }
    
    private let contentLabel2 = UILabel().then {
        $0.text = "2. 개인정보 수집 항목\n - 이메일, 생년월일, 성별, 거주지, 계좌"
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray500
    }
    
    private let contentLabel3 = UILabel().then {
        $0.text = "3. 개인정보 수집 이용 목적\n - 이벤트 운영 및 광고성 정보 전송"
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray500
    }
    
    private let contentLabel4 = UILabel().then {
        $0.text = "4. 보유 및 이용 기간\n - 동의 철회 시 또는 회원 탈퇴 시까지"
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray500
    }
    
    private let contentLabel5 = UILabel().then {
        $0.text = "5. 동의 철회 방법\n - 개인정보관리 페이지에서 변경 혹은 이메일으로 문의"
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray500
    }
    
    private let contentLabel6 = UILabel().then {
        $0.text = "6. 전송 방법\n - 앱 자체 알림"
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray500
    }
    
    private let contentLabel7 = UILabel().then {
        $0.text = "7. 전송 내용\n - 혜택 정보, 이벤트 정보, 상품 정보, 신규 서비스 안내 등의 광고성 정보 제공"
        $0.numberOfLines = 0
        $0.textAlignment = .justified
        $0.font = .pretendard(size: 14, weight: .regular)
        $0.textColor = .gray500
    }
    
    lazy var agreeButton = UIButton().then {
        $0.setTitle("동의하고 화면 닫기", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.backgroundColor = .gray500
        $0.layer.cornerRadius = 8
        $0.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .mainWhite
        setNavigationBar()
        addSubViews()
        setFont()
        setConstraints()
    }
    func setFont() {
        contentLabel2.asFont(targetString: "제 1조(목적)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel3.asFont(targetString: "제 2조(용어의 정리)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel4.asFont(targetString: "제 3조(약관 등의 명시와 설명 및 개정)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel5.asFont(targetString: "제 4조(서비스의 제공)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel6.asFont(targetString: "제 5조(서비스 이용계약의 성립)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel7.asFont(targetString: "제 6조(개인정보의 관리 및 보호)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
    }
    
    func setNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        self.navigationItem.title = "마케팅 활용동의"
        self.navigationItem.hidesBackButton = true
        let cancelButtonImage = UIImage(named: "cancel-black")
        let cancelButton = UIBarButtonItem(image: cancelButtonImage, style: .plain,target: self, action: #selector(cancelButtonTapped))
        navigationItem.leftBarButtonItem = cancelButton
    }
    
    func addSubViews() {
        [scrollView,
         agreeButton].forEach { view.addSubview($0) }
        scrollView.addSubview(contentView)
        [contentLabel,
         contentLabel1,
         contentLabel2,
         contentLabel3,
         contentLabel4,
         contentLabel5,
         contentLabel6,
         contentLabel7].forEach { contentView.addSubview($0) }
    }
    
    @objc func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        NotificationCenter.default.post(name: NSNotification.Name("UpdateCell"), object: 2)
        NotificationCenter.default.post(name: NSNotification.Name("CheckButtonChecked"), object: nil)
        navigationController?.popViewController(animated: true)
    }

    
    func setConstraints() {
        // 스크롤 뷰
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide.snp.top).offset(46)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.bottom.equalTo(agreeButton.snp.top).offset(-12)
        }
        
        // 콘텐트 뷰
        contentView.snp.makeConstraints {
            $0.width.equalTo(scrollView.frameLayoutGuide)
            $0.edges.equalTo(scrollView.contentLayoutGuide)
        }
        
        // 콘텐트 Label
        contentLabel.snp.makeConstraints {
            $0.leading.equalTo(contentView.snp.leading).offset(16)
            $0.top.equalTo(contentView.snp.top).offset(16)
        }
        
        contentLabel1.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        contentLabel2.snp.makeConstraints {
            $0.top.equalTo(contentLabel1.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        contentLabel3.snp.makeConstraints {
            $0.top.equalTo(contentLabel2.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        contentLabel4.snp.makeConstraints {
            $0.top.equalTo(contentLabel3.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        contentLabel5.snp.makeConstraints {
            $0.top.equalTo(contentLabel4.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        contentLabel6.snp.makeConstraints {
            $0.top.equalTo(contentLabel5.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
        }
        
        contentLabel7.snp.makeConstraints {
            $0.top.equalTo(contentLabel6.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.bottom.equalToSuperview().offset(-16)
        }
        
        // 화면 닫기 Button
        agreeButton.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).offset(-33)
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalToSuperview().offset(-24)
            $0.height.equalTo(52)
        }
    }
}
