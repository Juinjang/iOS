//
//  ShareWritePeriodCell.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

import UIKit
import Then
import SnapKit
import RxRelay
import RxSwift

final class ShareWritePeriodCell: BaseCollectionViewCell {
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "임장 시기"
        $0.fontAlignment = .left
    }
    
    private let periodBaseButton = UIButton().then {
        $0.backgroundColor = .gray100
    }
    
    private let periodStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 24
        $0.distribution = .equalSpacing
    }
    
    private let yearPeriodView = ImjangPeriodView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private let monthPeriodView = ImjangPeriodView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private let phasePeriodView = ImjangPeriodView().then {
        $0.isUserInteractionEnabled = false
    }
    
    private var disposeBag = DisposeBag()
    
    func bind(model: ShareWritePeriodCellItem,
              relay: PublishRelay<Void>) {
        yearPeriodView.configure(
            model: .year(model.periodModel.year),
            isDoneEdit: model.isDoneEdit
        )
        
        monthPeriodView.configure(
            model: .month(model.periodModel.month),
            isDoneEdit: model.isDoneEdit
        )
        
        phasePeriodView.configure(
            model: .phase(model.periodModel.phase),
            isDoneEdit: model.isDoneEdit
        )
        
        periodBaseButton.rx.throttleTap
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(
            titleLabel,
            periodBaseButton.with(
                yearPeriodView,
                monthPeriodView,
                phasePeriodView
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.left.equalToSuperview().offset(24)
        }
        
        periodBaseButton.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(40)
        }
        
        yearPeriodView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        monthPeriodView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(yearPeriodView.snp.right).offset(16)
        }
        
        phasePeriodView.snp.makeConstraints {
            $0.height.equalTo(32)
            $0.centerY.equalToSuperview()
            $0.left.equalTo(monthPeriodView.snp.right).offset(16)
        }
    }
}
