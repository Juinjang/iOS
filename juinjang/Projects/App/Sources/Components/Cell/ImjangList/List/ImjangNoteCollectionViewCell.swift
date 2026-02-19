//
//  ImjangNoteCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/19/24.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class ImjangNoteCollectionViewCell: UICollectionViewCell {
    let roomThumbnailImageView = UIImageView()
    let roomNameLabel = UILabel()
    let roomIcon = UIImageView()
    let roomNameStackView = UIStackView()
    let priceLabel = DSLabel(.body).then {
        $0.fontColor = .gray450
    }
    let pyungAndFloorLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .gray400
    }
    let addressLabel = UILabel()
    let starIcon = UIImageView()
    let scoreLabel = UILabel()
    let starStackView = UIStackView()
    let bookMarkButton = UIButton()
    private let baseLineView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    private let seperatorView = UIView()
    
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
        roomThumbnailImageView.image = nil
        roomThumbnailImageView.kf.setImage(with: URL(string: ""))
        roomIcon.image = UIImage.ImjangNote.house
    }
}

// MARK: - Configure Cell
extension ImjangNoteCollectionViewCell {
    func configureCell(note: NoteDTO?) {
        guard let note else { return }
        roomThumbnailImageView.kf.setImage(with: URL(string: ""))
        roomThumbnailImageView.image = nil

        roomNameLabel.text = note.name
        
        if let purposeType = PurposeType(rawValue: note.purposeType) {
            switch purposeType {
            case .INVESTMENT:
                roomIcon.image = .coin
            case .RESIDENTIAL_PURPOSE:
                roomIcon.image = UIImage.ImjangNote.house
            }
        }
        
        setScore(score: note.rate)
                
        if note.pyong == nil || note.floor == nil {
            pyungAndFloorLabel.text = "평층 미입력"
            pyungAndFloorLabel.textColor = .null
        } else {
            if let pyong = note.pyong, let floor = note.floor {
                pyungAndFloorLabel.textColor = .gray400
                pyungAndFloorLabel.text = "\(pyong)평 \(floor)층"
            }
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

        if let priceType = PriceType(rawValue: note.priceType) {
            setPriceLabel(note: note, priceType: priceType)
        }
        
        let image = note.isScraped ? UIImage.bookmarkOn22 : UIImage.bookmarkOff22
        bookMarkButton.setImage(image, for: .normal)
        
        let images = note.imageUrl
        
        if images.isEmpty || images.count == 0 {
            if let propertyType = PropertyType(rawValue: note.propertyType) {
                roomThumbnailImageView.image = propertyType.detailImage
            } else {
                roomThumbnailImageView.image = UIImage.ImjangList.empty
            }
        } else {
            let image = images[0]
            if let url = URL(string: image) {
                self.roomThumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
            }
        }
    }
    
    // 가격 설정
    private func setPriceLabel(note: NoteDTO, priceType: PriceType) {
        if (note.price?.isEmpty ?? true) || note.price == "0" {
            priceLabel.text = "가격 미입력"
            priceLabel.fontColor = .gray450
            return
        } else {
            priceLabel.fontColor = .gray600
        }
        
        switch priceType {
        case .SALE, .PULL_RENT, .MARKET_PRICE:
            priceLabel.text = "\(priceType.title) \(note.price?.formatToKoreanCurrencyWithZero() ?? "")"
        case .MONTHLY_RENT:
            priceLabel.text = "\(priceType.title) \(note.price?.formatToKoreanCurrencyWithZero() ?? "") / \(note.monthlyRent?.oneSplitAmount().addingCommas() ?? "")"
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
    
    private func setPyungAndFloor(model: NoteDTO) {
        if let pyung = model.pyong,
           let floor = model.floor {
            pyungAndFloorLabel.text = "\(pyung)평 \(floor)층"
        } else {
            pyungAndFloorLabel.text = "평층 미입력"
        }
    }
    
    func setScoreStyle(empty: Bool = true) {
        starIcon.image = empty ? UIImage.starEmpty : UIImage.star.withRenderingMode(.alwaysOriginal)
        scoreLabel.textColor = empty ? .null : .main
    }
}

// MARK: - Configure UI
extension ImjangNoteCollectionViewCell {
    
    private func configureHierarchy() {
        contentView.add(
            roomThumbnailImageView,
            roomNameLabel,
            roomIcon,
            priceLabel,
            pyungAndFloorLabel,
            addressLabel,
            scoreLabel,
            starIcon,
            bookMarkButton,
            seperatorView
        )
    }
    
    private func configureLayout() {
        roomThumbnailImageView.snp.makeConstraints {        // 방 썸네일 사진
            $0.leading.equalToSuperview()
            $0.centerY.equalToSuperview()
            $0.width.equalTo(144)
            $0.height.equalTo(112)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.top.equalTo(roomThumbnailImageView.snp.top).offset(3.5)
            $0.leading.equalTo(roomThumbnailImageView.snp.trailing).offset(12)
        }
        
        roomNameLabel.snp.makeConstraints {
            $0.top.equalTo(roomThumbnailImageView.snp.top).offset(1)
            $0.leading.equalTo(roomIcon.snp.trailing).offset(4)
            $0.centerY.equalTo(roomIcon)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.height.equalTo(23)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(roomNameLabel.snp.bottom)
            $0.leading.equalTo(roomIcon.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        pyungAndFloorLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.leading.equalTo(roomIcon.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(roomIcon.snp.leading)
            $0.top.equalTo(pyungAndFloorLabel.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(19)
        }
    
        bookMarkButton.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(22)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.bottom.equalTo(roomThumbnailImageView.snp.bottom).offset(-2)
            $0.leading.equalTo(starIcon.snp.trailing).offset(3)
            $0.height.equalTo(20)
        }
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.leading.equalTo(roomIcon.snp.leading)
            $0.centerY.equalTo(scoreLabel.snp.centerY)
        }
        
        seperatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        roomThumbnailImageView.layer.cornerRadius = 6
        roomThumbnailImageView.clipsToBounds = true
    }
    
    private func configureView() {
        contentView.backgroundColor = .mainWhite
        
        roomThumbnailImageView.contentMode = .scaleAspectFill
        
        roomIcon.design(image: UIImage.ImjangNote.house, contentMode: .scaleAspectFit)
        roomNameLabel.design(text:"", font: .pretendard(size: 16, weight: .bold))
        
        priceLabel.fontColor = .gray450
        
        addressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 13, weight: .medium))
        
        starIcon.design(image: UIImage.starRounded.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        starIcon.tintColor = .main
        
        scoreLabel.design(text:"", textColor: .main, font: .pretendard(size: 14, weight: .semiBold))
        scoreLabel.textColor = .main
        
        bookMarkButton.design(image: UIImage.bookmarkOff22, backgroundColor: .clear)
        
        seperatorView.backgroundColor = .stroke
    }
}
