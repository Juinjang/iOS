//
//  MarketingUseViewController.swift
//  juinjang
//
//  Created by 박도연 on 3/30/24.
//
import UIKit
import Then
import SnapKit

final class MarketingUseViewController : BaseViewController {
   private let scrollView = UIScrollView().then {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.isScrollEnabled = true
        $0.indicatorStyle = .black
        $0.showsVerticalScrollIndicator = true
        $0.backgroundColor = .gray100
    }
    
//    private let contentLabel1 = UILabel().then {
//        $0.text = "마케팅 활용동의"
//        $0.font = UIFont(name: "Pretendard-SemiBold", size: 16)
//        $0.numberOfLines = 0
//        $0.textAlignment = .center
//    }
    
    private let contentLabel2 = UILabel().then {
        $0.text = "1. 마케팅 활용 동의 (선택)\n주인장은 개인정보 보호법 제 22조 제4항과 제39조의 3에 따라 사용자의 광고성 정보 수신과 이에 따른 개인정보 처리에 대한 동의를 받고 있습니다. 약관에 동의하지 않으셔도 주인장의 모든 서비스를 이용하실 수 있습니다. 다만, 이벤트, 혜택 등의 제한이 있을 수 있습니다."
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel3 = UILabel().then {
        $0.text = "2. 개인정보 수집 항목\n- 이메일, 생년월일, 성별, 거주지, 계좌"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel4 = UILabel().then {
        $0.text = "3. 개인정보 수집 이용 목적 \n- 이벤트 운영 및 광고성 정보 전송\n- 서비스 관련 정보 전송"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel5 = UILabel().then {
        $0.text = "4. 보유 및 이용 기간\n- 동의 철회 시 또는 회원 탈퇴 시까지"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel6 = UILabel().then {
        $0.text = "5. 동의 철회 방법\n- 개인정보관리 페이지에서 변경 혹은 이메일으로 문의"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel7 = UILabel().then {
        $0.text = "6. 전송 방법\n- 앱 자체 알림"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
    private let contentLabel8 = UILabel().then {
        $0.text = "7. 전송 내용\n- 혜택 정보, 이벤트 정보, 상품 정보, 신규 서비스 안내 등의 광고성 정보 제공"
        $0.font = UIFont(name: "Pretendard-Light", size: 14)
        $0.numberOfLines = 0
        $0.textAlignment = .justified
    }
    
//MARK: - 함수
    func designNavigationBar() {
        self.navigationController?.navigationBar.tintColor = .black
        navigationItem.title = "마케팅 활용동의"
        
        let closeButtonItem = UIBarButtonItem(image: UIImage(named:"arrow-left"), style: .plain, target: self, action: #selector(tapCloseButton))
        closeButtonItem.tintColor = .gray450
        closeButtonItem.imageInsets = UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 0)

        // 네비게이션 아이템에 백 버튼 아이템 설정
        self.navigationItem.leftBarButtonItem = closeButtonItem
    }
    @objc func tapCloseButton() {
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func setConstraint() {
        scrollView.snp.makeConstraints {
            $0.top.equalTo(view.safeAreaLayoutGuide).offset(46)
            $0.left.right.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(33)
        }
        contentLabel2.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
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
        }
        contentLabel8.snp.makeConstraints {
            $0.top.equalTo(contentLabel7.snp.bottom).offset(4)
            $0.left.right.equalToSuperview().inset(16)
            $0.width.equalTo(scrollView.snp.width).inset(16)
            $0.bottom.equalToSuperview().inset(16)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        designNavigationBar()
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentLabel2)
        scrollView.addSubview(contentLabel3)
        scrollView.addSubview(contentLabel4)
        scrollView.addSubview(contentLabel5)
        scrollView.addSubview(contentLabel6)
        scrollView.addSubview(contentLabel7)
        scrollView.addSubview(contentLabel8)
        contentLabel2.asFont(targetString: "1. 마케팅 활용 동의 (선택)", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel3.asFont(targetString: "2. 개인정보 수집 항목", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel4.asFont(targetString: "3. 개인정보 수집 이용 목적", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel5.asFont(targetString: "4. 보유 및 이용 기간", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel6.asFont(targetString: "5. 동의 철회 방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel7.asFont(targetString: "6. 전송 방법", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
        contentLabel8.asFont(targetString: "7. 전송 내용", font: UIFont(name: "Pretendard-Medium", size: 14) ?? .systemFont(ofSize: 14))
       
        view.backgroundColor = .mainWhite
        setConstraint()
    }
}



