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
    case cellTap(id: Int)
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
    
    private let buildingNameLabel = UILabel().then {
        $0.textColor = .gray600
        $0.font = .pretendard(size: 16, weight: .bold)
        $0.lineBreakMode = .byTruncatingTail
        $0.numberOfLines = 1
    }

    private let purchaseLabel = UILabel().then {
        $0.backgroundColor = .point.withAlphaComponent(0.1)
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
        $0.text = "소장"
        $0.textAlignment = .center
        $0.textColor = .point
        $0.font = .pretendard(size: 12, weight: .medium)
    }
    
    private let priceLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray450
    }
    
    private let spaceInfoLabel = UILabel().then {
        $0.font = .pretendard(size: 14, weight: .medium)
        $0.textColor = .gray400
    }
    
    private let addressLabel = UILabel().then {
        $0.font = .pretendard(size: 13, weight: .medium)
        $0.textColor = .gray400
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
            with: URL(string: model.imageUrl),
            placeholder: UIImage.randomCardPlaceholderImage
        )
        rateLabel.rateNumber = model.rate
        likeButton.isSelected = model.isLike
        buildingNameLabel.text = model.bulidingName
        purchaseLabel.isHidden = !model.isPurchase
        priceLabel.text = "\(model.type) \(model.price)"
        spaceInfoLabel.text = "\(model.pyong)평 \(model.floor)"
        addressLabel.text = "\(model.address)"
        metaInfoView.configure(.init(model))
        
        likeButton.rx.throttleTap
            .map { MyNoteCellEventType.likeButtonTap(id: model.sharedNoteId) }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        cellTapButton.rx.throttleTap
            .map { MyNoteCellEventType.cellTap(id: model.sharedNoteId) }
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
