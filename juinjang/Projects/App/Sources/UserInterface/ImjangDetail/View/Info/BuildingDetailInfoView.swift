//
//  BuildingDetailInfoView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/13/25.
//

import UIKit
import Then
import SnapKit
import RxRelay
import RxSwift
import RxCocoa

final class BuildingDetailInfoView: BaseView {
    private let summaryInfoLabel = DSLabel(.body2).then {
        $0.fontColor = .gray450
    }
    
    private let dotLabel = DSLabel(.body2).then {
        $0.fontColor = .gray400
        $0.text = "·"
    }
    
    private let secondSummaryInfoLabel = DSLabel(.body2).then {
        $0.fontColor = .gray450
    }
    
    private let likeButton = UIButton().then {
        $0.setImage(.heartBigEmpty, for: .normal)
        $0.setImage(.heartBigFill, for: .selected)
    }
    
    private let likeCountLabel = DSLabel(.body2).then {
        $0.fontColor = .main
    }
    
    private let priceLabel = DSLabel(.h2).then {
        $0.fontColor = .gray600
    }
    
    private let addressBaseButton = UIButton().then {
        $0.backgroundColor = .gray100
        $0.roundCorners(cornerRadius: 10, corner: .all)
    }
    
    private let locationIconView = UIImageView().then {
        $0.image = .location1
        $0.tintColor = .gray300
    }
    
    private let addressContentLabel = DSLabel(.body2).then {
        $0.fontSize = 15
        $0.fontColor = .gray400
        $0.numberOfLines = 2
    }
    
    private let sharedDateLabel = DSLabel(.body2).then {
        $0.fontColor = .gray400
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    private var dispoaseBag = DisposeBag()
        
    func configure(for model: ImjangDetailInfoModel,
                   relay: PublishRelay<ImjangDetailInfoCellEvent>) {
        self.dispoaseBag = DisposeBag()
        guard let priceType = PriceType(rawValue: model.priceType)?.title else { return }
        summaryInfoLabel.text = model.addressShort
        secondSummaryInfoLabel.text = PropertyType(rawValue: model.propertyType)?.title
        likeButton.isSelected = model.isLiked
        likeCountLabel.text = "\(model.likedCount.viewCountString)"
        priceLabel.text = "\(priceType) \(model.price.formattedKoreanCurrency)"
        addressContentLabel.text = model.address
        sharedDateLabel.text = "\(model.period) · 조회 \(model.viewCount)"
        
        likeButton.rx.throttleTap(milliseconds: 2000)
            .withHaptic()
            .subscribe(with: self) { (self,_) in
                relay.accept(.likeButtonTap)
            }
            .disposed(by: dispoaseBag)
        
        addressBaseButton.rx.throttleTap
            .subscribe(with: self) { (self, _) in
                relay.accept(.addressTap(address: model.address))
            }
            .disposed(by: dispoaseBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            summaryInfoLabel,
            dotLabel,
            secondSummaryInfoLabel,
            likeButton,
            likeCountLabel,
            priceLabel,
            addressBaseButton.with(
                locationIconView,
                addressContentLabel
            ),
            sharedDateLabel,
            separatorView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        summaryInfoLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(20)
            $0.left.equalToSuperview().offset(24)
        }
        
        dotLabel.snp.makeConstraints {
            $0.centerY.equalTo(summaryInfoLabel.snp.centerY)
            $0.left.equalTo(summaryInfoLabel.snp.right).offset(4)
        }
        
        secondSummaryInfoLabel.snp.makeConstraints {
            $0.centerY.equalTo(summaryInfoLabel.snp.centerY)
            $0.left.equalTo(dotLabel.snp.right).offset(4)
        }
        
        likeButton.snp.makeConstraints {
            $0.top.equalTo(summaryInfoLabel.snp.top).offset(4)
            $0.right.equalToSuperview().inset(33)
        }
        
        likeCountLabel.snp.makeConstraints {
            $0.top.equalTo(likeButton.snp.bottom)
            $0.centerX.equalTo(likeButton.snp.centerX)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(summaryInfoLabel.snp.bottom)
            $0.height.equalTo(27)
            $0.left.equalToSuperview().offset(24)
        }
        
        addressBaseButton.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom).offset(12.5)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(58)
        }
        
        locationIconView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
        }
        
        addressContentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(locationIconView.snp.right).offset(8)
            $0.right.equalToSuperview().inset(10)
            $0.height.equalTo(45)
        }
        
        sharedDateLabel.snp.makeConstraints {
            $0.top.equalTo(addressBaseButton.snp.bottom).offset(12)
            $0.left.equalToSuperview().offset(24)
        }
        
        separatorView.snp.makeConstraints {
            $0.bottom.equalToSuperview()
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
