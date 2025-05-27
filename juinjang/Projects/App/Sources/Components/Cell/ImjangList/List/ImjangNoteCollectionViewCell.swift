//
//  ImjangNoteCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/19/24.
//

import UIKit
import Then
import SnapKit

final class ImjangNoteCollectionViewCell: UICollectionViewCell {
    private let roomThumbnailImageView = UIImageView()
    private let roomNameLabel = UILabel()
    private let roomIcon = UIImageView()
    
    private let priceLabel = DSLabel(.body)
    private let pyongFloorLabel = DSLabel(.reguler).then {
        $0.fontWeight = .medium
        $0.fontColor = .gray400
    }
    private let addressLabel = UILabel()
    
    private let starIcon = UIImageView()
    private let scoreLabel = UILabel()
    
    let bookMarkButton = UIButton()
    
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
        configureCell(note: nil)
        self.roomThumbnailImageView.image = nil
    }
}

// MARK: - Configure Cell
extension ImjangNoteCollectionViewCell {
    func configureCell(note: NoteDTO?) {
        guard let note else { return }
        

        roomNameLabel.text = note.name
        setScore(score: note.rate)
        
        priceLabel.text = note.price
        
        if note.pyong == nil || note.floor == nil {
            pyongFloorLabel.text = "이 집의 평수와 층수를 알려주세요"
        } else {
            if let pyong = note.pyong, let floor = note.floor {
                pyongFloorLabel.text = "\(pyong)평 \(floor)층"
            }
        }
        
        addressLabel.text = note.address

        if let priceType = PriceType(rawValue: note.priceType) {
            setPriceLabel(note: note, priceType: priceType)
        }
        
        addressLabel.text = note.address
        
        let image = note.isScraped ? UIImage.ImjangList.bookmarkSelected : UIImage.ImjangList.bookmark
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
            priceLabel.text = "\(priceType.title) \(String(describing: note.price.formatToKoreanCurrencyWithZero()))"
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
    
    func setScoreStyle(empty: Bool = true) {
        starIcon.tintColor = empty ? .null : .main
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
            pyongFloorLabel,
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
            $0.verticalEdges.equalToSuperview().inset(12)
            $0.width.equalTo(144)
            $0.height.equalTo(112)
        }
        
        roomNameLabel.snp.makeConstraints {
            $0.top.equalTo(roomThumbnailImageView.snp.top).offset(1)
            $0.leading.equalTo(roomThumbnailImageView.snp.trailing).offset(12)
            $0.height.equalTo(23)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.equalTo(roomNameLabel.snp.trailing).offset(4)
            $0.trailing.lessThanOrEqualToSuperview()
            $0.centerY.equalTo(roomNameLabel)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(roomNameLabel.snp.bottom)
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        pyongFloorLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(19)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.top.equalTo(pyongFloorLabel.snp.bottom)
            $0.trailing.equalToSuperview()
            $0.height.equalTo(19)
        }
    
        bookMarkButton.snp.makeConstraints {
            $0.bottom.equalTo(contentView).inset(12)
            $0.trailing.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.bottom.equalTo(roomThumbnailImageView.snp.bottom).offset(-2)
            $0.leading.equalTo(starIcon.snp.trailing).offset(3)
            $0.height.equalTo(20)
        }
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.leading.equalTo(roomNameLabel.snp.leading)
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
        
        scoreLabel.design(text:"", textColor: .main, font: .pretendard(size: 14, weight: .semiBold))
        
        bookMarkButton.design(image: UIImage.ImjangList.bookmark, backgroundColor: .clear)
        
        seperatorView.backgroundColor = .stroke
    }
}
