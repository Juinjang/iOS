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
        $0.distribution = .equalSpacing
        $0.spacing = 4
        $0.backgroundColor = .stroke2
    }
    
    let emptyBackgroundView = UIView().then {
        $0.backgroundColor = .stroke2
    }
    let emptyImage = UIImageView().then {
        $0.image = UIImage.Main.gallery
        $0.contentMode = .scaleAspectFit
    }
    
    // 방 이름 레이블
    let roomNameStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 4
    }
    let roomNameLabel = UILabel()
    let roomIcon = UIImageView()
    
    
    let starStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.distribution = .equalSpacing
        $0.spacing = 2
    }
    let starIcon = UIImageView()
    let scoreLabel = UILabel()
    
    let roomPriceLabel = UILabel()
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
        setData(imjangNote: nil)
    }
}
    
// MARK: - Configure Cell
extension ScrapCollectionViewCell {
    
    func setData(imjangNote: MyImjangResponseDTO?) {
        guard let imjangNote else { return }
        roomNameLabel.text = imjangNote.name
        setScore(score: imjangNote.rate)
        let priceTypeString: String
        switch imjangNote.priceType {
        case "SALE":
            priceTypeString = "매매"
        case "PULL_RENT":
            priceTypeString = "전세"
        case "MONTHLY_RENT":
            priceTypeString = "월세"
        case "MARKET_PRICE":
            priceTypeString = "실거래가"
        default:
            priceTypeString = "" // 값이 없을 경우 공백 처리
        }
        setPriceLabel(price: imjangNote.price, priceType: priceTypeString)
        roomAddressLabel.text = imjangNote.address
        let bookmarkImage = imjangNote.isScraped ? UIImage.ImjangList.bookmarkSelected : UIImage.ImjangList.bookmark
        bookMarkButton.setImage(bookmarkImage, for: .normal)
        
        let images = imjangNote.imageUrl
        switch images.count {
        case 0:
            setStackViewBackground(isEmpty: true)
        case 1:
            setImage1(image: images[0])
            setStackViewBackground(isEmpty: false)
        case 2:
            setImage2(images: images)
            setStackViewBackground(isEmpty: false)
        case 3...:
            setImage3(images: images)
            setStackViewBackground(isEmpty: false)
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
            $0.distribution = .equalSpacing
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
    
    private func setPriceLabel(price: String, priceType: String) {
        roomPriceLabel.text = "\(priceType) \(price.formatToKoreanCurrencyWithZero())"
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
    
    private func setStackViewBackground(isEmpty: Bool) {
        emptyImage.isHidden = isEmpty ? false : true
        if isEmpty {
            totalStackView.addSubview(emptyImage)
            emptyImage.snp.makeConstraints {
                $0.center.equalTo(totalStackView)
                $0.size.equalTo(50)
            }
        }
        totalStackView.backgroundColor = isEmpty ? .stroke2 : .mainWhite
    }
}


// MARK: - Configure UI
extension ScrapCollectionViewCell {
    private func configureHierarchy() {
        [totalStackView, roomNameStackView, starStackView, roomPriceLabel, roomAddressLabel, bookMarkButton].forEach {
            contentView.addSubview($0)
        }
        
        [roomNameLabel, roomIcon].forEach {
            roomNameStackView.addArrangedSubview($0)
        }
        
        [starIcon, scoreLabel].forEach {
            starStackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {

        totalStackView.snp.makeConstraints {
            $0.top.leading.trailing.equalToSuperview().inset(12)
            $0.height.equalTo(117)
        }
        
        roomNameStackView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(12)
            $0.top.equalTo(totalStackView.snp.bottom).offset(8)
            $0.height.equalTo(24)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(18)
        }
        
        starStackView.snp.makeConstraints {
            $0.verticalEdges.equalTo(roomNameStackView)
            $0.trailing.equalToSuperview().inset(12)
        }
        starIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        roomPriceLabel.snp.makeConstraints {
            $0.horizontalEdges.equalTo(totalStackView)
            $0.top.equalTo(roomNameStackView.snp.bottom)
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
    
    override func draw(_ rect: CGRect) {
        totalStackView.layer.cornerRadius = 5
    }
    
    private func configureView() {
        contentView.backgroundColor = .mainWhite
        
        contentView.layer.borderColor = UIColor.stroke.cgColor
        contentView.layer.borderWidth = 1.5
        contentView.layer.cornerRadius = 10
        contentView.layer.masksToBounds = true
        
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.05
        layer.shadowRadius = 6
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.masksToBounds = false
        
        roomNameLabel.design(text: "", font: .pretendard(size: 18, weight: .bold))
        roomIcon.design(image: UIImage.ImjangNote.house, contentMode: .scaleAspectFit)
        
        starIcon.design(image: UIImage.starEmpty, contentMode: .scaleAspectFit)
        scoreLabel.design(textColor: .null, font: .pretendard(size: 16, weight: .semiBold))
        roomPriceLabel.design(text: "", font: .pretendard(size: 16, weight: .semiBold))
        roomAddressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 14, weight: .medium))
        bookMarkButton.design(image: UIImage.ImjangList.bookmark, backgroundColor: .mainWhite)
    }
}
