//
//  SelectNoteCell.swift
//  juinjang
//
//  Created by 조유진 on 5/31/25.
//

import UIKit
import Then
import SnapKit

final class SelectNoteCell: UICollectionViewCell {
    private let roomThumbnailImageView = UIImageView()
    private let roomNameLabel = UILabel()
    private let coinIcon = UIImageView()
    
    private let priceLabel = DSLabel(.body)
    private let pyongFloorLabel = DSLabel(.reguler).then {
        $0.fontWeight = .medium
        $0.fontColor = .gray400
    }
    private let addressLabel = UILabel()
    
    private let starIcon = UIImageView()
    private let scoreLabel = UILabel()
    
    let bookMarkButton = UIButton()
    
    var isClicked = false {
        didSet {
            setSelectStyle(isSelected: isClicked)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(note: nil)
        self.roomThumbnailImageView.image = nil
        coinIcon.image = .coin
        setSelectStyle(isSelected: false)
    }
}

// MARK: - Configure Cell
extension SelectNoteCell {
    func configureCell(note: NoteDTO?) {
        guard let note else { return }

        roomNameLabel.text = note.name
        
        if let purposeType = PurposeType(rawValue: note.purposeType) {
            switch purposeType {
            case .INVESTMENT:
                coinIcon.image = .coin
            case .RESIDENTIAL_PURPOSE:
                coinIcon.image = UIImage.ImjangNote.house
            }
        }
        
        setScore(score: note.rate)
        
        priceLabel.text = note.price
        
        if note.pyong == nil || note.floor == nil {
            pyongFloorLabel.text = "평층 미입력"
            pyongFloorLabel.textColor = .null
        } else {
            if let pyong = note.pyong, let floor = note.floor {
                pyongFloorLabel.text = "\(pyong)평 \(floor)층"
                pyongFloorLabel.textColor = .gray400
            }
        }
    
        if let priceType = PriceType(rawValue: note.priceType) {
            setPriceLabel(note: note, priceType: priceType)
        }
        
        addressLabel.textColor = .gray400
        if let address = note.address {
            addressLabel.text = address
        } else {
            if let shortAddress = note.shortAddress {
                addressLabel.text = shortAddress
            } else {
                addressLabel.text = "주소 미입력"
                addressLabel.textColor = .null
            }
        }
        
        let image = note.isScraped ? UIImage.bookmarkOn22 : UIImage.bookmarkOff22
        bookMarkButton.setImage(image, for: .normal)
        
        let images = note.imageUrl
        if images.isEmpty {
            if let propertyType = PropertyType(rawValue: note.propertyType) {
                roomThumbnailImageView.image = propertyType.detailImage
            } else {
                roomThumbnailImageView.image = UIImage.ImjangList.empty
            }
        } else {
            let image = images[0]
            if let url = URL(string: image) {
                DispatchQueue.main.async {
                    self.roomThumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
                }
            }
        }
    }
    
    // 가격 설정
    private func setPriceLabel(note: NoteDTO, priceType: PriceType) {
        switch priceType {
        case .SALE, .PULL_RENT, .MARKET_PRICE:
            priceLabel.text = "\(priceType.title) \(note.price.formatToKoreanCurrencyWithZero())"
        case .MONTHLY_RENT:
            priceLabel.text = "\(priceType.title) \(note.price.formatToKoreanCurrencyWithZero()) / \(note.monthlyRent?.oneSplitAmount().addingCommas() ?? "")"
        }
    }
    
    private func setScore(score: String?) {
        guard let score, let doubleScore = Double(score) else {
            scoreLabel.text = "0.0"
            setScoreStyle()
            return
        }
        
        let resultScore = doubleScore.truncateToSingleDecimal()
        scoreLabel.text = String(format: "%.1f", resultScore)
        
        if resultScore == 0.0 {
            setScoreStyle()
        } else {
            setScoreStyle(empty: false)
        }
    }
    
    private func setScoreStyle(empty: Bool = true) {
        starIcon.image = empty ? UIImage.starEmpty : UIImage.star
        scoreLabel.textColor = empty ? .null : .main
    }
    
    func setSelectStyle(isSelected: Bool) {
        if isSelected {
            contentView.layer.borderColor = UIColor.main.cgColor
            contentView.layer.borderWidth = 1
            contentView.backgroundColor = .bg2
        } else {
            contentView.layer.borderColor = UIColor.stroke.cgColor
            contentView.layer.borderWidth = 1
            contentView.backgroundColor = .mainWhite
        }
    }
}

// MARK: - Configure UI
extension SelectNoteCell {
    
    private func configureHierarchy() {
        contentView.add(
            roomThumbnailImageView,
            roomNameLabel,
            coinIcon,
            priceLabel,
            pyongFloorLabel,
            addressLabel,
            scoreLabel,
            starIcon,
            bookMarkButton
        )
    }
    
    private func configureLayout() {
        roomThumbnailImageView.snp.makeConstraints {        // 방 썸네일 사진
            $0.leading.equalToSuperview().inset(12)
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.width.equalTo(144)
            $0.height.equalTo(112)
        }
        
        coinIcon.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.equalTo(roomThumbnailImageView.snp.trailing).offset(12)
            $0.top.equalTo(roomThumbnailImageView.snp.top).offset(2.5)
        }
        
        roomNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(coinIcon)
            $0.leading.equalTo(coinIcon.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview().inset(12)
            $0.height.equalTo(23)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(roomNameLabel.snp.bottom)
            $0.leading.equalTo(coinIcon.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        pyongFloorLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.leading.equalTo(coinIcon.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(coinIcon.snp.leading)
            $0.top.equalTo(pyongFloorLabel.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(19)
        }
    
        bookMarkButton.snp.makeConstraints {
            $0.bottom.trailing.equalToSuperview().inset(13)
            $0.size.equalTo(22)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.bottom.equalTo(roomThumbnailImageView.snp.bottom).offset(-2)
            $0.leading.equalTo(starIcon.snp.trailing).offset(3)
            $0.height.equalTo(20)
        }
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.leading.equalTo(coinIcon.snp.leading)
            $0.centerY.equalTo(scoreLabel.snp.centerY)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roomThumbnailImageView.layer.cornerRadius = 6
        roomThumbnailImageView.clipsToBounds = true
    }
    
    private func configureView() {
        contentView.backgroundColor = .mainWhite
        contentView.layer.cornerRadius = 10
        setSelectStyle(isSelected: false)
        
        roomThumbnailImageView.contentMode = .scaleAspectFill
        
        coinIcon.design(image: UIImage.coin, contentMode: .scaleAspectFit)
        roomNameLabel.design(text:"", font: .pretendard(size: 16, weight: .bold))
        
        priceLabel.fontColor = .gray450
        
        addressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 13, weight: .medium))
        
        starIcon.design(image: UIImage.starRounded.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        starIcon.tintColor = .main
        
        scoreLabel.design(text:"", textColor: .main, font: .pretendard(size: 14, weight: .semiBold))
        
        bookMarkButton.design(image: UIImage.bookmarkOff22, backgroundColor: .clear)
        bookMarkButton.isUserInteractionEnabled = false
    }
}
