//
//  ReportCompletedAlertView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/31/25.
//

import UIKit
import Then
import SnapKit
import RxSwift

final class ReportCompletedAlertView: BaseAlertViewController {
    private let baseView = UIView()
    
    private let checkIconView = UIImageView().then {
        $0.image = .CheckList.checkedButton
    }
    
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "신고 되었어요"
        $0.textAlignment = .center
    }
    
    private let contentLabel = DSLabel(.body2).then {
        $0.fontColor = .gray400
        $0.text = "주인장을 위해 신고해주셔서 감사해요.\n신고된 내용은 확인 후 적절한 조치를 취할 예정이에요."
        $0.textAlignment = .center
    }
    
    private let closeButton = UIButton().then {
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.setTitle("닫기", for: .normal)
        $0.setTitleColor(.mainWhite, for: .normal)
        $0.titleLabel?.font = UIFont.pretendard(
            size: 16,
            weight: .semiBold
        )
        $0.backgroundColor = .gray500
    }
    
    private let disposeBag = DisposeBag()
    
    init() {
        super.init(
            height: 240,
            isBackgroundDismissEnabled: true,
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
            checkIconView,
            titleLabel,
            contentLabel,
            closeButton
        )
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        baseView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        checkIconView.snp.makeConstraints {
            $0.size.equalTo(40)
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().offset(28)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(checkIconView.snp.bottom).offset(12)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalTo(titleLabel.snp.bottom).offset(8)
        }
        
        closeButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(52)
            $0.bottom.equalToSuperview().offset(-12)
        }
    }
    
    private func bind() {
        closeButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                self.dismiss(animated: true)
            }
            .disposed(by: disposeBag)
    }
}
