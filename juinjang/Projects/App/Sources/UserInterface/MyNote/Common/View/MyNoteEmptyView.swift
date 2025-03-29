//
//  MyNoteEmptyCell.swift
//  juinjang
//
//  Created by KimDongWoo on 3/17/25.
//

import UIKit
import Then
import SnapKit
import RxRelay
import RxSwift

final class MyNoteEmptyView: BaseView {
    private var disposeBag = DisposeBag()
    private let baseView = UIView()
    private let emptyIconView = UIImageView().then {
        $0.image = .emptyCell
    }
    
    private let contentLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray400
    }
    
    private let filledButton = UIButton().then {
        $0.titleLabel?.font = .pretendard(size: 16, weight: .semiBold)
        $0.titleLabel?.textColor = .white
        $0.titleLabel?.textAlignment = .center
        $0.backgroundColor = .gray500
        $0.roundCorners(cornerRadius: 10, corner: .all)
    }
    
    let filledButtonRelay = PublishRelay<Void>()
        
    func configure(text: String,
                   isShowButton: Bool = false,
                   buttonTitle: String = "") {
        disposeBag = DisposeBag()
        contentLabel.text = text
        filledButton.isHidden = !isShowButton
        filledButton.setTitle(buttonTitle, for: .normal)
        filledButton.rx.throttleTap
            .bind(to: filledButtonRelay)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(
            baseView.with(
                emptyIconView,
                contentLabel
            ),
            filledButton
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(185)
            $0.horizontalEdges.equalToSuperview()
        }
        
        emptyIconView.snp.makeConstraints {
            $0.top.centerX.equalToSuperview()
            $0.width.equalTo(216)
            $0.height.equalTo(154)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(emptyIconView.snp.bottom).offset(8)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        filledButton.snp.makeConstraints {
            $0.width.equalTo(202)
            $0.height.equalTo(52)
            $0.centerX.equalToSuperview()
            $0.top.equalTo(contentLabel.snp.bottom).offset(32)
        }
    }
}
