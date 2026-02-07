//
//  ScrapCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/26/24.
//

import UIKit
import Then
import Kingfisher

final class ScrapCollectionViewCell: UICollectionViewCell {
    var totalStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.distribution = .fill
        $0.spacing = 4
        $0.backgroundColor = .stroke2
    }
    
    let emptyBackgroundView = UIView().then {
        $0.backgroundColor = .stroke2
    }
    let emptyImage = UIImageView()
    
    let roomNameLabel = DSLabel(.h3)
    let roomIcon = UIImageView()
    
    let starIcon = UIImageView()
    let scoreLabel = DSLabel(.title)
    
    let roomPriceLabel = DSLabel(.title)
    let roomAddressLabel = UILabel()
    let bookMarkButton = UIButton()
    
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
        totalStackView.subviews.forEach { subview in
            subview.removeFromSuperview()
        }
        roomIcon.image = UIImage.ImjangNote.house
        setData(note: nil)
    }
}
    
// MARK: - Configure Cell
extension ScrapCollectionViewCell {
    func setData(note: NoteDTO?) {
        guard let note else { return }
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
        
        roomAddressLabel.textColor = .gray400
        if let address = note.address {
            roomAddressLabel.text = address
        } else {
            if let shortAddress = note.shortAddress {
                roomAddressLabel.text = shortAddress
            } else {
                roomAddressLabel.text = "주소 미입력"
                roomAddressLabel.textColor = .null
            }
        }

        if let priceType = PriceType(rawValue: note.priceType) {
            setPriceLabel(note: note, priceType: priceType)
        }
        
        let bookmarkImage = note.isScraped ? UIImage.ImjangList.bookmarkSelected : UIImage.ImjangList.bookmark
        bookMarkButton.setImage(bookmarkImage, for: .normal)
        
        let images = note.imageUrl
        switch images.count {
        case 0:
            setStackViewBackground(propertyType: note.propertyType, isEmpty: true)
        case 1:
            setImage1(image: images[0])
            setStackViewBackground(propertyType: note.propertyType, isEmpty: false)
        case 2:
            setImage2(images: images)
            setStackViewBackground(propertyType: note.propertyType, isEmpty: false)
        case 3...:
            setImage3(images: images)
            setStackViewBackground(propertyType: note.propertyType, isEmpty: false)
        default:
            print("알 수 없는 오류 발생")
        }
    }
    
    private func setImage1(image: String) {
        let firstImageView = ImjangImageView(frame: .zero)
        totalStackView.addArrangedSubview(firstImageView)
        if let url = URL(string: image) {
            DispatchQueue.main.async {
                firstImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
            }
        }
        
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 5
            firstImageView.clipsToBounds = true
        }
    }
    
    private func setImage2(images: [String]) {
        let firstImageView = ImjangImageView(frame: .zero)
        let secondImageView = ImjangImageView(frame: .zero)
        
        [firstImageView, secondImageView].forEach { totalStackView.addArrangedSubview($0)}
        
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(firstImageView.snp.width).multipliedBy(117.0 / 174.0)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(117.0 / 109.0)
        }
        
        if let url1 = URL(string: images[0]) {
            DispatchQueue.main.async {
                firstImageView.kf.setImage(with: url1, placeholder: UIImage(named: "1"))
            }
        }
        if let url2 = URL(string: images[1]) {
            DispatchQueue.main.async {
                secondImageView.kf.setImage(with: url2, placeholder: UIImage(named: "2"))
            }
        }
        
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 5
            secondImageView.layer.cornerRadius = 5
            firstImageView.clipsToBounds = true
            secondImageView.clipsToBounds = true
        }
    }
    
    private func setImage3(images: [String]) {
        let firstImageView = ImjangImageView(frame: .zero)
        let secondImageView = ImjangImageView(frame: .zero)
        let thirdImageView = ImjangImageView(frame: .zero)
        
        let imageVStackView = UIStackView().then {
            $0.axis = .vertical
            $0.alignment = .fill
            $0.distribution = .fill
            $0.spacing = 5
        }
        
        [firstImageView, imageVStackView].forEach {
            totalStackView.addArrangedSubview($0)
        }

        [secondImageView, thirdImageView].forEach {
            imageVStackView.addArrangedSubview($0)
        }
               
        let secondHeight: Double = UIScreen.main.isWiderThan375pt ? 67 : 80
        let thirdHeight: Double = UIScreen.main.isWiderThan375pt ? 48 : 58
        
        let firstWidth: Double = UIScreen.main.isWiderThan428pt ? 186 : 174
        let secondWidth: Double = UIScreen.main.isWiderThan428pt ? 130 : 105
        firstImageView.snp.makeConstraints {
            $0.height.equalTo(firstImageView.snp.width).multipliedBy(117.0 / firstWidth)
        }
        
        secondImageView.snp.makeConstraints {
            $0.height.equalTo(secondImageView.snp.width).multipliedBy(secondHeight / secondWidth)
        }
        
        thirdImageView.snp.makeConstraints {
            $0.height.equalTo(thirdImageView.snp.width).multipliedBy(thirdHeight / secondWidth)
        }
        
        if let url1 = URL(string: images[0]) {
            DispatchQueue.main.async {
                firstImageView.kf.setImage(with: url1, placeholder: UIImage(named: "1"))
            }
        }
        if let url2 = URL(string: images[1]) {
            DispatchQueue.main.async {
                secondImageView.kf.setImage(with: url2, placeholder: UIImage(named: "2"))
            }
        }
        if let url3 = URL(string: images[2]) {
            DispatchQueue.main.async {
                thirdImageView.kf.setImage(with: url3, placeholder: UIImage(named: "3"))
            }
        }
        
        DispatchQueue.main.async {
            firstImageView.layer.cornerRadius = 5
            secondImageView.layer.cornerRadius = 5
            thirdImageView.layer.cornerRadius = 5
            firstImageView.clipsToBounds = true
            secondImageView.clipsToBounds = true
            thirdImageView.clipsToBounds = true
        }
    }
    
    private func setPriceLabel(note: NoteDTO, priceType: PriceType) {
        if note.price == "" || note.price == "0" {
            roomPriceLabel.text = "가격 미입력"
            roomPriceLabel.fontColor = .gray450
            return
        } else {
            roomPriceLabel.fontColor = .gray600
        }
        
        switch priceType {
        case .SALE, .PULL_RENT, .MARKET_PRICE:
            roomPriceLabel.text = "\(priceType.title) \( note.price.formatToKoreanCurrencyWithZero())"
        case .MONTHLY_RENT:
            roomPriceLabel.text = "\(priceType.title) \(note.price.formatToKoreanCurrencyWithZero()) / \(note.monthlyRent?.oneSplitAmount().addingCommas() ?? "")"
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
    
    private func setStackViewBackground(propertyType: String, isEmpty: Bool) {
        emptyImage.isHidden = isEmpty ? false : true
        if isEmpty {
            totalStackView.addArrangedSubview(emptyImage)
            
            if let propertyType = PropertyType(rawValue: propertyType) {
                emptyImage.image = propertyType.detailImage
            }
        }
        totalStackView.backgroundColor = isEmpty ? .stroke2 : .mainWhite
    }
}


// MARK: - Configure UI
extension ScrapCollectionViewCell {
    private func configureHierarchy() {
        contentView.add(
            totalStackView,
            roomNameLabel,
            roomIcon,
            scoreLabel,
            starIcon,
            roomPriceLabel,
            roomAddressLabel,
            bookMarkButton
        )
    }
    
    private func configureLayout() {
        totalStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(117)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.leading.equalToSuperview().inset(12)
            $0.top.equalTo(totalStackView.snp.bottom).offset(11)
        }
        
        roomNameLabel.snp.makeConstraints {
            $0.centerY.equalTo(roomIcon)
            $0.leading.equalTo(roomIcon.snp.trailing).offset(2)
            $0.trailing.lessThanOrEqualTo(starIcon.snp.leading).offset(-2).priority(.required)
            $0.height.equalTo(24)
        }
        
        roomNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        roomNameLabel.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        
        scoreLabel.snp.makeConstraints {
            $0.top.equalTo(totalStackView.snp.bottom).offset(8)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(23)
        }
        
        scoreLabel.setContentHuggingPriority(.required, for: .horizontal)
        scoreLabel.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.centerY.equalTo(roomIcon)
            $0.trailing.equalTo(scoreLabel.snp.leading).offset(-2)
        }
        
        starIcon.setContentHuggingPriority(.required, for: .horizontal)
        starIcon.setContentCompressionResistancePriority(.required, for: .horizontal)
        
        roomPriceLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(totalStackView)
            $0.top.equalTo(roomNameLabel.snp.bottom)
            $0.height.equalTo(23)
        }
        
        roomAddressLabel.snp.makeConstraints {
            $0.leading.equalTo(totalStackView)
            $0.bottom.equalTo(contentView).inset(9)
            $0.height.equalTo(20)
        }
        
        bookMarkButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(contentView).inset(12)
            $0.size.equalTo(18)
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        totalStackView.layer.cornerRadius = 5
    }
    
    private func configureView() {
        contentView.backgroundColor = .mainWhite
        
        contentView.layer.borderColor = UIColor.stroke.cgColor
        contentView.layer.borderWidth = 1
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
        
        roomNameLabel.design(text: "", font: .pretendard(size: 18, weight: .bold))
        roomIcon.design(image: UIImage.ImjangNote.house, contentMode: .scaleAspectFit)
        
        starIcon.design(image: UIImage.starRounded.withRenderingMode(.alwaysTemplate), contentMode: .scaleAspectFit)
        
        starIcon.tintColor = .main
        scoreLabel.fontColor = .main
        
        roomAddressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 14, weight: .medium))
        bookMarkButton.design(image: UIImage.ImjangList.bookmark, backgroundColor: .mainWhite)
    }
}
