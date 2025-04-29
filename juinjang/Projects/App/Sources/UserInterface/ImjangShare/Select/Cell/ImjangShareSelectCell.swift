//
//  ImjangShareSelectCell.swift
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

final class ImjangShareSelectCell: BaseCollectionViewCell {
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
    
    func bind(item: ImjangShareSelectCellItem,
              relay: PublishRelay<String>) {
        disposeBag = DisposeBag()
        
        guard let priceType = PriceType(rawValue: item.model.priceType)?.title else { return }
        
        tumbnailImageView.kf.setImage(
            with: URL(string: item.model.imageUrl),
            placeholder: PropertyType(rawValue: item.model.propertyType)?.image
        )
        buildingNameLabel.text = item.model.name
        priceLabel.text = "\(priceType) \(item.model.price.formattedKoreanCurrency)"
        pyungLabel.text = "\(item.model.pyong)평 \(item.model.floor)층"
        addressLabel.text = item.model.shortAddress
        starRateLabel.text = "\(item.model.rate ?? 0.0)"
        bookmarkButton.isSelected = item.model.isScraped
        
        item.isSelected
        ? setupViewForSelected()
        : setupViewForDeselected()
        
        containerButton.rx.throttleTap
            .map { item.id }
            .bind(to: relay)
            .disposed(by: disposeBag)
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

extension ImjangShareSelectCell {
    private func setupViewForSelected() {
        containerButton.layer.borderColor = UIColor.main.cgColor
        containerButton.backgroundColor = .bg2
    }
    
    private func setupViewForDeselected() {
        containerButton.layer.borderColor = UIColor.stroke.cgColor
        containerButton.backgroundColor = .mainWhite
    }
}
