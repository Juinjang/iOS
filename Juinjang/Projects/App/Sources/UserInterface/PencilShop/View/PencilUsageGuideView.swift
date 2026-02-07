//
//  PencilUsageGuideView.swift
//  juinjang
//
//  Created by 조유진 on 4/1/25.
//

import UIKit
import RxSwift
import SnapKit
import RxRelay

final class PencilUsageGuideView: BaseView {
    private let headerView = UIView().then {
        $0.backgroundColor = .gray200
    }
    private let titleLabel = UILabel().then {
        $0.setAttribute(text: "연필 이용안내", color: .gray450, font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
    }
    
    private let arrowImageView = UIImageView().then {
        $0.design(image: .arrow16Down, contentMode: .scaleAspectFit)
    }
    
    private let dividorView = UIView().then {
        $0.backgroundColor = .gray300
    }
    
    private let textView = UITextView().then {
        $0.text = """
        1. 연필 유효기간
        • 2025년 7월 18일까지 유료로 구매한 연필의 유효기간은 결제 시점을 기준으로 5년입니다.
        
        2. 연필 환불
        • iOS 앱에서 충전한 연필의 환불은 APPLE 고객센터를 통해서만 가능합니다.
        • 환불 시에는 결제한 수단으로 환불됩니다.
        • 보너스 연필 및 이벤트로 받은 무료 연필은 환불 대상이 아닙니다.
        
        3. 환불 신청 방법
        • APPLE 고객센터로 정상적인 환불이 진행되지 않았을 시에 아래 메일로 연락해주세요.
            • [juinjang1227@gmail.com]
        
        4. 인앱 결제 및 환불 신청
        ① 사용자는 Apple App Store(iOS) 인앱 결제 시스템을 통해 별도의 앱 내 유상 재화(이하 '연필')를 구매할 수 있습니다.
        ② 사용자가 연필 구매 후 환불을 희망하는 경우, Apple 정책에 따라 Apple에 직접 환불을 신청해야 하며, 환불 가능 여부는 Apple의 심사 기준에 따릅니다.
        
        5. 환불 처리를 위한 연계 및 서버 연동
        ① Apple이 환불 처리를 진행하는 경우, 환불 요청 및 처리 관련 정보가 당사(이하 '운영자') 서버에 연동되어 전달됩니다.
        ② 환불이 승인될 경우, 운영자는 환불 금액에 상응하는 만큼 사용자의 계정에서 구매한 연필을 우선 차감합니다.
        
        6. 환불에 따른 연필 차감 방식
        ① 환불 금액에 해당하는 연필 수만큼, 우선적으로 구매한 연필에서 차감됩니다.
        ② 만약 구매한 연필 잔여분만으로 환불 금액이 충족되지 않을 경우,
        운영자는 사용자가 보유한 '얻은 연필'(이벤트/보상 등으로 획득한 무상 연필)에서도 추가로 차감 처리할 수 있습니다.
        ③ 구매한 연필과 얻은 연필까지 모두 차감하여도 환불 금액에 해당하는 연필 수량이 부족할 경우,
        사용자의 연필 잔고는 0개로 처리되며, 음수(마이너스)로 차감되지 않습니다.
        
        7. 유의 사항
        ① 환불 처리 후, 환불된 금액에 상응하는 연필 및 관련 콘텐츠 사용권한도 소멸할 수 있습니다.
        ② 환불 정책 및 재화 차감 규칙 등은 Apple의 정책 변경 또는 운영자 내부 기준에 따라 변경될 수 있으며, 변경 시 사전 공지합니다.
        """
 
        $0.textContainerInset = UIEdgeInsets(top: 16, left: 24, bottom: 42, right: 24)
        $0.backgroundColor = .gray200
        
        let font = UIFont.pretendard(size: 11, weight: .medium)
        
        let style = NSMutableParagraphStyle()
        style.maximumLineHeight = 14
        style.minimumLineHeight = 14
        style.lineBreakMode = .byWordWrapping
        
        let attributes: [NSAttributedString.Key: Any] = [
            .paragraphStyle: style,
            .kern: -0.02,
            .font: font,
            .foregroundColor: UIColor.gray400
        ]
        
        $0.attributedText = NSAttributedString(AttributedString($0.text, attributes: AttributeContainer(attributes)))
        $0.isEditable = false
        $0.isScrollEnabled = false
        $0.isHidden = true
    }
    
    private var disposeBag = DisposeBag()
    private var heightConstraint: Constraint?
    
    private let expandedHeight: CGFloat = 640 // 펼쳤을 때 높이 (수정 가능)
    private let collapsedHeight: CGFloat = 52 // 접었을 때 기본 높이
    let guideTapRelay = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            headerView.with(
                titleLabel,
                arrowImageView,
                dividorView
            ),
            textView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        headerView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(36)
        }
        
        dividorView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
    
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
        }
        
        arrowImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(16)
        }
        
        textView.snp.makeConstraints { make in
            make.top.equalTo(headerView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
            heightConstraint = make.height.equalTo(collapsedHeight).constraint
        }
    }
    
    override func configureView() {
        backgroundColor = .gray200
        setBold()
        let tapGesture = UITapGestureRecognizer()
        headerView.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .bind(with: self) { owner, _ in
                let isExpanded = !owner.textView.isHidden
                
                // 높이 변경
                owner.heightConstraint?.update(offset: isExpanded ? owner.collapsedHeight : owner.expandedHeight) // 예시: 펼쳤을 때 400
                
                owner.textView.isHidden.toggle()
                owner.arrowImageView.transform = isExpanded ? .identity : CGAffineTransform(rotationAngle: .pi)
                self.layoutIfNeeded()
                owner.guideTapRelay.accept(())
            }
            .disposed(by: disposeBag)
    }
    
    private func setBold() {
        ["1. 연필 유효기간",
         "2. 연필 환불",
         "3. 환불 신청 방법",
         "4. 인앱 결제 및 환불 신청",
         "5. 환불 처리를 위한 연계 및 서버 연동",
         "6. 환불에 따른 연필 차감 방식",
         "7. 유의 사항"
        ].forEach {
            applyFont(to: $0, font: .pretendard(size: 11, weight: .semiBold))
        }
    }
    
    func applyFont(to targetText: String, font: UIFont?) {
        guard let fullText = textView.text, let font = font else { return }
        
        let attributedString: NSMutableAttributedString
        
        if let existingAttributedText = textView.attributedText { // 기존 스타일 유지
            attributedString = NSMutableAttributedString(attributedString: existingAttributedText)
        } else { // 새로운 AttributedString 생성
            attributedString = NSMutableAttributedString(string: fullText)
        }
        
        var searchRange = fullText.startIndex..<fullText.endIndex
        
        while let range = fullText.range(of: targetText, options: .literal, range: searchRange) {
            let nsRange = NSRange(range, in: fullText)
            attributedString.addAttribute(.font, value: font, range: nsRange)
            
            // 다음 검색을 위해 범위를 이동
            searchRange = range.upperBound..<fullText.endIndex
        }
        
        textView.attributedText = attributedString
    }
}
