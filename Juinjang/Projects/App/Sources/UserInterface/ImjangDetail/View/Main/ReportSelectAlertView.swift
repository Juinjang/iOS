//
//  ReportSelectAlertView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/31/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

enum ReportReason: String, CaseIterable {
    case falseInformation = "FALSE_INFORMATION"
    case illegalBrokering = "ILLEGAL_BROKERING"
    case inappropriateContent = "INAPPROPRIATE_CONTENT"
    case personalInformationLeak = "PERSONAL_INFORMATION_LEAK"
    case infringement = "INFRINGEMENT"
    case spam = "SPAM"
    case etc = "ETC"
    
    var description: String {
        switch self {
        case .falseInformation: return "부정확한 정보 제공"
        case .illegalBrokering: return "거래 유도/불법 중개 행위"
        case .inappropriateContent: return "부적절한 내용 포함"
        case .personalInformationLeak: return "개인정보 노출"
        case .infringement: return "타인의 권리 침해"
        case .spam: return "반복성 스팸/도배"
        case .etc: return "기타"
        }
    }
}

enum ReportEventType {
    case updateSelectType(ReportReason)
    case reportButtonTap
}

final class ReportSelectAlertView: BaseAlertViewController {
    private let baseView = UIView()
    
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "신고하기"
        $0.fontAlignment = .left
    }
    
    private let contentLabel = DSLabel(.reguler).then {
        $0.fontColor = .gray450
        $0.text = "신고는 운영 정책에 따라 검토되며, 허위 신고 시 서비스 이용 제한이 적용될 수 있습니다."
        $0.fontAlignment = .left
    }
    
    private let selectItemStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 16
        $0.distribution = .fillEqually
    }
    
    private let cancelButton = UIButton().then {
        $0.backgroundColor = .gray3
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.setTitle("취소", for: .normal)
        $0.setTitleColor(.gray500, for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 16, weight: .semiBold)
    }
    
    private let reportButton = UIButton().then {
        $0.isEnabled = false
        $0.backgroundColor = .null
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.setTitle("신고하기", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(size: 16, weight: .semiBold)
    }
    
    private let buttonsStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 8
        $0.distribution = .fillEqually
    }
    
    private let disposeBag = DisposeBag()
    
    let reportEventRelay = PublishRelay<ReportEventType>()
    
    init() {
        super.init(
            height: 430,
            contentViews: [baseView],
            buttons: []
        )
        
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
        
        baseView.add(
            titleLabel,
            contentLabel,
            selectItemStackView,
            buttonsStackView
        )
        
        [cancelButton, reportButton].forEach {
            buttonsStackView.addArrangedSubview($0)
        }
        
        ReportReason.allCases.forEach { type in
            let button = ReportSelectItemButton(title: type.description)

            button.rx.throttleTap
                .subscribe(with: self) { (self, _) in
                    self.updateReportButtonState(isEnabled: true)
                    self.selectItemStackView.arrangedSubviews
                        .compactMap { $0 as? ReportSelectItemButton }
                        .forEach { $0.isSelected = false }

                    button.isSelected = true
                    self.reportEventRelay.accept(.updateSelectType(type))
                }
                .disposed(by: disposeBag)

            selectItemStackView.addArrangedSubview(button)
        }
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        selectItemStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.height.equalTo(224)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        buttonsStackView.snp.makeConstraints {
            $0.height.equalTo(52)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func bind() {
        cancelButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
        
        reportButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                self.reportEventRelay.accept(.reportButtonTap)
            }
            .disposed(by: disposeBag)
    }
    
    private func updateReportButtonState(isEnabled: Bool) {
        reportButton.backgroundColor = isEnabled ? .gray500 : .null
        reportButton.isEnabled = isEnabled
    }
}
