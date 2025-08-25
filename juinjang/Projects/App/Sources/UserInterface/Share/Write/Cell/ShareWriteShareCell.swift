//
//  ShareWriteShareCell.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class ShareWriteShareCell: BaseCollectionViewCell {
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "공유할 임장"
        $0.fontAlignment = .left
    }
    
    private let containerView = UIView().then {
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
    
    func bind(item: ShareSelectModel) {
        tumbnailImageView.kf.setImage(
            with: URL(string: item.imageUrl ?? ""),
            placeholder: PropertyType(rawValue: item.propertyType)?.image
        )
        buildingNameLabel.text = item.name
        setPrice(item.priceType, priceType: item.priceType, monthlyRent: item.monthlyRent)
        pyungLabel.text = "\(item.pyong)평 \(item.floor)층"
        addressLabel.text = item.shortAddress
        starRateLabel.text = String(format: "%.1f", Double(item.rate ?? "0.0") ?? 0.0)
        bookmarkButton.isSelected = item.isScraped
    }
    
    private func setPrice(_ priceString: String, priceType: String, monthlyRent: String?) {
        guard let priceType = PriceType(rawValue: priceType) else { return }
        
        var priceResult = ""
        
        switch priceType {
        case .SALE, .PULL_RENT, .MARKET_PRICE:
            priceResult = "\(priceType.title) \(priceString.formatToKoreanCurrencyWithZero())"
        case .MONTHLY_RENT:
            priceResult = "\(priceType.title) \(priceString.formatToKoreanCurrencyWithZero()) / \(monthlyRent?.oneSplitAmount().addingCommas() ?? "")"
        }
        
        priceLabel.setAttribute(
            text: priceResult,
            color: .gray450,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23
        )
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(
            titleLabel,
            containerView.with(
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
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(8)
            $0.left.equalToSuperview().offset(24)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(16)
        }
        
        tumbnailImageView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.left.equalToSuperview().offset(12)
            $0.width.equalTo(144)
        }
        
        buildingNameLabel.snp.makeConstraints {
            $0.top.equalTo(tumbnailImageView.snp.top)
            $0.left.equalTo(tumbnailImageView.snp.right).offset(12)
            $0.height.equalTo(23)
        }
        
        coinIconView.snp.makeConstraints {
            $0.left.equalTo(buildingNameLabel.snp.right)
            $0.centerY.equalTo(buildingNameLabel.snp.centerY)
            $0.size.equalTo(18)
        }
        
        priceLabel.snp.makeConstraints {
            $0.left.equalTo(tumbnailImageView.snp.right).offset(12)
            $0.top.equalTo(buildingNameLabel.snp.bottom)
            $0.height.equalTo(23)
        }
        
        pyungLabel.snp.makeConstraints {
            $0.left.equalTo(tumbnailImageView.snp.right).offset(12)
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.height.equalTo(19)
        }
        
        addressLabel.snp.makeConstraints {
            $0.left.equalTo(tumbnailImageView.snp.right).offset(12)
            $0.top.equalTo(pyungLabel.snp.bottom)
            $0.height.equalTo(19)
        }
        
        starIconView.snp.makeConstraints {
            $0.left.equalTo(tumbnailImageView.snp.right).offset(12)
            $0.top.equalTo(addressLabel.snp.bottom).offset(9)
            $0.size.equalTo(12)
        }
        
        starRateLabel.snp.makeConstraints {
            $0.left.equalTo(starIconView.snp.right).offset(4)
            $0.centerY.equalTo(starIconView.snp.centerY)
        }
        
        bookmarkButton.snp.makeConstraints {
            $0.right.equalToSuperview().inset(12)
            $0.centerY.equalTo(starRateLabel.snp.centerY)
            $0.size.equalTo(22)
        }
    }
}
