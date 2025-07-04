//
//  MyNoteCell.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit
import SnapKit
import Then
import RxSwift
import RxCocoa
import Kingfisher

enum MyNoteCellEventType: Equatable {
    case likeButtonTap(id: Int)
    case cellTap(id: Int, title: String)
}

final class MyNoteCell: UICollectionViewCell {
    private let thumbnailImageView = UIImageView().then {
        $0.layer.cornerRadius = 6
        $0.layer.masksToBounds = true
        $0.isUserInteractionEnabled = true
    }
    
    private let rateLabel = MyNoteStarRateLabel()
    
    private let likeButton = UIButton().then {
        $0.setImage(.lineHeart, for: .normal)
        $0.setImage(.lineHeartFill, for: .selected)
    }
    
    private let buildingInfoBaseView = UIView()
    
    private let buildingNameLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
        $0.fontWeight = .bold
    }

    private let purchaseLabel = DSLabel(.body).then {
        $0.backgroundColor = .point.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.text = "소장"
        $0.fontAlignment = .center
        $0.fontColor = .point
        $0.fontSize = 12
    }
    
    private let priceLabel = DSLabel(.body).then {
        $0.fontColor = .gray450
        $0.fontSize = 16
    }
    
    private let spaceInfoLabel = DSLabel(.body).then {
        $0.fontColor = .gray400
        $0.fontSize = 14
    }
    
    private let addressLabel = DSLabel(.body).then {
        $0.fontSize = 13
        $0.fontColor = .gray400
    }
    
    private let metaInfoView = MyNoteMetaInfoView().then {
        $0.backgroundColor = .systemBlue
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    private let cellTapButton = UIButton().then {
        $0.backgroundColor = .clear
    }
        
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        thumbnailImageView.kf.cancelDownloadTask()
        thumbnailImageView.image = nil
        buildingNameLabel.text = nil
        purchaseLabel.isHidden = true
        priceLabel.text = nil
        spaceInfoLabel.text = nil
        addressLabel.text = nil
        likeButton.isSelected = false
        metaInfoView.reset()
        rateLabel.reset()
        disposeBag = DisposeBag()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.bringSubviewToFront(likeButton)
    }
    
    func bind(_ model: MyNoteCellModel,
              relay: PublishRelay<MyNoteCellEventType>) {
        thumbnailImageView.kf.setImage(
            with: URL(string: model.imageUrl ?? ""),
            placeholder: PropertyType(rawValue: model.propertyType)?.image
        )
        rateLabel.rateNumber = model.rate
        likeButton.isSelected = model.isLike
        buildingNameLabel.text = model.buildingName
        purchaseLabel.isHidden = !model.isPurchase
        priceLabel.text = "\(model.priceType.priceTypeToViewText) \(model.price.formattedKoreanCurrency)"
        spaceInfoLabel.text = "\(model.pyong ?? 0)평 \(model.floor ?? "")층"
        addressLabel.text = "\(model.address)"
        metaInfoView.configure(.init(model))
        configureStopShareLayout(model)
        
        likeButton.rx.throttleTap
            .map { MyNoteCellEventType.likeButtonTap(id: model.sharedNoteId) }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        cellTapButton.rx.throttleTap
            .map { MyNoteCellEventType.cellTap(id: model.sharedNoteId, title: model.buildingName) }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }

    private func configureHierarchy() {
        contentView.add([
            thumbnailImageView.with(rateLabel),
            likeButton,
            buildingInfoBaseView.with(
                buildingNameLabel,
                purchaseLabel,
                priceLabel,
                spaceInfoLabel,
                addressLabel,
                metaInfoView
            ),
            cellTapButton,
            separatorView
        ])
        
    }
    
    private func configureLayout() {
        thumbnailImageView.snp.makeConstraints {
            $0.width.equalTo(144)
            $0.height.equalTo(112)
            $0.left.equalToSuperview().offset(24)
            $0.centerY.equalToSuperview()
        }
        
        rateLabel.snp.makeConstraints {
            $0.width.equalTo(40)
            $0.height.equalTo(19)
            $0.left.top.equalToSuperview()
        }
        
        likeButton.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.right.bottom.equalTo(thumbnailImageView).inset(8)
        }
        
        buildingInfoBaseView.snp.makeConstraints {
            $0.top.bottom.equalToSuperview().inset(12)
            $0.left.equalTo(thumbnailImageView.snp.right).offset(12)
            $0.right.equalToSuperview().inset(12)
        }
        
        buildingNameLabel.snp.makeConstraints {
            $0.height.equalTo(23)
            $0.top.left.equalToSuperview()
        }
        
        purchaseLabel.snp.makeConstraints {
            $0.height.equalTo(17)
            $0.width.equalTo(29)
            $0.centerY.equalTo(buildingNameLabel.snp.centerY)
            $0.left.equalTo(buildingNameLabel.snp.right).offset(4)
        }
        
        priceLabel.snp.makeConstraints {
            $0.height.equalTo(23)
            $0.top.equalTo(buildingNameLabel.snp.bottom)
            $0.left.equalToSuperview()
        }
        
        spaceInfoLabel.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.left.equalToSuperview()
        }
        
        addressLabel.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.top.equalTo(spaceInfoLabel.snp.bottom)
            $0.left.equalToSuperview()
        }
        
        metaInfoView.snp.makeConstraints {
            $0.height.equalTo(18)
            $0.top.equalTo(addressLabel.snp.bottom).offset(3)
            $0.left.equalToSuperview()
        }
        
        cellTapButton.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}

// MARK: - StopShare Layout Update
extension MyNoteCell {
    private func configureStopShareLayout(_ model: MyNoteCellModel) {
        if model.isStopShare {
            separatorView.isHidden = true
            layer.masksToBounds = true
            layer.cornerRadius = 10
            
            thumbnailImageView.snp.remakeConstraints {
                $0.width.equalTo(144)
                $0.height.equalTo(112)
                $0.left.equalToSuperview().offset(12)
                $0.centerY.equalToSuperview()
            }
            
            model.isSelected ? updateStopShareSelectedView() : updateStopShareDefaultView()
        }
    }
    
    private func updateStopShareDefaultView() {
        backgroundColor = .mainWhite
        layer.borderWidth = 1
        layer.borderColor = UIColor.stroke.cgColor
        layer.cornerRadius = 12
    }
    
    private func updateStopShareSelectedView() {
        backgroundColor = .bg2
        layer.borderWidth = 1
        layer.borderColor = UIColor.main.cgColor
        layer.cornerRadius = 12
    }
}
