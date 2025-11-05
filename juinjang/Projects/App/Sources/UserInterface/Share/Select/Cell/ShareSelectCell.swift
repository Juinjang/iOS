//
//  ShareSelectCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import Kingfisher

final class ShareSelectCell: BaseCollectionViewCell {
    private var disposeBag = DisposeBag()
    
    private let containerButton = UIButton().then {
        $0.roundCorners(cornerRadius: 10, corner: .all)
        $0.layer.borderColor = UIColor.stroke.cgColor
        $0.layer.borderWidth = 1
        $0.backgroundColor = .mainWhite
    }
    
    private let tumbnailImageView = UIImageView().then {
        $0.roundCorners(cornerRadius: 6, corner: .all)
        $0.contentMode = .scaleAspectFill
    }
    
    private let buildingNameLabel = DSLabel(.h3).then {
        $0.fontSize = 16
        $0.fontColor = .gray600
        $0.fontAlignment = .left
    }
    
    private let coinIconView = UIImageView().then {
        $0.image = .coin
    }
    
    private let priceLabel = DSLabel(.body).then {
        $0.fontColor = .gray450
    }
    
    private let pyungLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .gray400
    }
    
    private let addressLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .gray400
    }
    
    private let starIconView = UIImageView().then {
        $0.image = .starMain14
        $0.contentMode = .scaleAspectFit
    }
    
    private let starRateLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .main
    }
    
    private let bookmarkButton = UIButton().then {
        $0.setImage(.bookmarkOff22, for: .normal)
        $0.setImage(.bookmarkOn22, for: .selected)
    }
    
    func bind(item: ShareSelectCellItem,
              relay: PublishRelay<String>) {
        disposeBag = DisposeBag()
        
        tumbnailImageView.kf.setImage(
            with: URL(string: item.model.imageUrl ?? ""),
            placeholder: PropertyType(rawValue: item.model.propertyType)?.image
        )
        buildingNameLabel.text = item.model.name
        setPrice(item.model.price, priceType: item.model.priceType, monthlyRent: item.model.monthlyRent)
        pyungLabel.text = "\(item.model.pyong)평 \(item.model.floor)층"
        addressLabel.text = item.model.shortAddress
        starRateLabel.text = String(format: "%.1f", Double(item.model.rate ?? "0.0") ?? 0.0)
        bookmarkButton.isSelected = item.model.isScraped
        
        item.isSelected
        ? setupViewForSelected()
        : setupViewForDeselected()
        
        containerButton.rx.throttleTap
            .map { item.id }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    private func setPrice(_ priceString: String, priceType: String, monthlyRent: String?) {
        guard let priceType = PriceType(rawValue: priceType) else { return }
        
        var price = ""
        let priceTitle = priceType == .MARKET_PRICE ? "\(priceType.title)" : "\(priceType.title)"
        
        switch priceType {
        case .SALE, .PULL_RENT, .MARKET_PRICE:
            price = "\(priceString.formatToKoreanCurrencyWithZero())"
        case .MONTHLY_RENT:
            price = "\(priceString.formatToKoreanCurrencyWithZero()) / \(monthlyRent?.oneSplitAmount().addingCommas() ?? "")"
        }
        
        priceLabel.text = "\(priceTitle) \(price)"
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(
            containerButton.with(
                tumbnailImageView,
                buildingNameLabel,
                coinIconView,
                priceLabel,
                pyungLabel,
                addressLabel,
                starIconView,
                starRateLabel,
                bookmarkButton
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        containerButton.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(6)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        tumbnailImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().offset(12)
            $0.width.equalTo(144)
        }
        
        coinIconView.snp.makeConstraints {
            $0.leading.equalTo(tumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(tumbnailImageView.snp.top)
            $0.size.equalTo(18)
        }
        
        buildingNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(coinIconView.snp.centerY)
            $0.leading.equalTo(coinIconView.snp.trailing).offset(2)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
            $0.height.equalTo(23)
        }
        
        priceLabel.snp.makeConstraints {
            $0.leading.equalTo(tumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(buildingNameLabel.snp.bottom)
            $0.height.equalTo(23)
        }
        
        pyungLabel.snp.makeConstraints {
            $0.leading.equalTo(tumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.height.equalTo(19)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(tumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(pyungLabel.snp.bottom)
            $0.height.equalTo(19)
        }
        
        starIconView.snp.makeConstraints {
            $0.leading.equalTo(tumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(addressLabel.snp.bottom).offset(9)
            $0.size.equalTo(12)
        }
        
        starRateLabel.snp.makeConstraints {
            $0.leading.equalTo(starIconView.snp.trailing).offset(4)
            $0.centerY.equalTo(starIconView.snp.centerY)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(12)
            $0.centerY.equalTo(starRateLabel.snp.centerY)
            $0.size.equalTo(22)
        }
    }
}

extension ShareSelectCell {
    private func setupViewForSelected() {
        containerButton.layer.borderColor = UIColor.main.cgColor
        containerButton.backgroundColor = .bg2
    }
    
    private func setupViewForDeselected() {
        containerButton.layer.borderColor = UIColor.stroke.cgColor
        containerButton.backgroundColor = .mainWhite
    }
}
