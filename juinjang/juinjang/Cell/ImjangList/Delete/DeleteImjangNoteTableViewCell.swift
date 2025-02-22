//
//  DeleteImjangNoteTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/27/24.
//

import UIKit

final class DeleteImjangNoteTableViewCell: UITableViewCell {
    let roomThumbnailImageView = UIImageView()
    let roomNameLabel = UILabel()
    let roomIcon = UIImageView()
    let roomNameStackView = UIStackView()
    let priceLabel = UILabel()
    let starIcon = UIImageView()
    let scoreLabel = UILabel()
    let starStackView = UIStackView()
    let addressLabel = UILabel()
    let checkImageView = UIImageView()
    
    var isClicked = false {
        didSet {
            checkImageView.image = isClicked ? UIImage.ImjangList.on : UIImage.ImjangList.off
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [roomThumbnailImageView, roomNameStackView, priceLabel, starStackView, addressLabel, checkImageView].forEach {
            contentView.addSubview($0)
        }
        [roomNameLabel, roomIcon].forEach {
            roomNameStackView.addArrangedSubview($0)
        }
        [starIcon, scoreLabel].forEach {
            starStackView.addArrangedSubview($0)
        }
        designView()
        setConstraints()
    }

    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 8, right: 24))
    }
    
    private func setPriceLabel(priceList: [String]) {
        switch priceList.count {
        case 1:
            let priceString = priceList[0]
            priceLabel.text = priceString.formatToKoreanCurrencyWithZero()
        case 2:
            let priceString1 = priceList[0].formatToKoreanCurrencyWithZero()
            let priceString2 = priceList[1].formatToKoreanCurrencyWithZero()
            priceLabel.text = "\(priceString1) • 월 \(priceString2)"
            priceLabel.asColor(targetString: "•", color: UIColor.mainStroke)
        default:
            priceLabel.text = "편집을 통해 가격을 설정해주세요."
        }
    }

    func configureCell(imjangNote: ListDto?) {
        guard let imjangNote else { return }
        let images = imjangNote.images
        if images.isEmpty {
            roomThumbnailImageView.image = UIImage.ImjangList.empty
        } else {
            if let url = URL(string: images[0]) {
                roomThumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
            } else {
                roomThumbnailImageView.image = UIImage(named: "1")
            }
        }
        
        
        roomNameLabel.text = imjangNote.nickname
        setPriceLabel(priceList: imjangNote.priceList)
        
        setScore(score: imjangNote.totalAverage)
        
        addressLabel.text = imjangNote.address
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
    
    private func setConstraints() {
        
        checkImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalTo(contentView).inset(16)
            $0.size.equalTo(20)
        }
        
        roomThumbnailImageView.snp.makeConstraints {        // 방 썸네일 사진
            $0.leading.equalTo(contentView.snp.leading).offset(12)
            $0.centerY.equalTo(contentView)
            $0.size.equalTo(82)
        }
        
        roomNameStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(12)
            $0.leading.equalTo(roomThumbnailImageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(checkImageView.snp.leading).inset(12)
            $0.height.equalTo(24)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(roomNameStackView.snp.bottom)
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.trailing.greaterThanOrEqualTo(checkImageView.snp.leading).inset(12)
        }
        
        starStackView.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.trailing.greaterThanOrEqualTo(contentView.snp.trailing).inset(12)
        }
        
        starIcon.snp.makeConstraints {
            $0.width.height.equalTo(14)
        }
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.top.equalTo(starStackView.snp.bottom)
            $0.trailing.greaterThanOrEqualTo(checkImageView.snp.leading).inset(12)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(imjangNote: nil)
    }
    
    override func draw(_ rect: CGRect) {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.stroke.cgColor
        DispatchQueue.main.async {
            self.roomThumbnailImageView.layer.cornerRadius = 5
            self.roomThumbnailImageView.clipsToBounds = true
        }
    }
    
    private func designView() {
        contentView.backgroundColor = .mainWhite
        roomThumbnailImageView.contentMode = .scaleAspectFill
        
        roomNameStackView.axis = .horizontal
        roomNameStackView.spacing = 4
        roomNameStackView.alignment = .center
        roomNameStackView.distribution = .fill
        
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.alignment = .center
        starStackView.distribution = .fill

        
        roomIcon.design(image: UIImage.ImjangNote.house, contentMode: .scaleAspectFit)
        roomNameLabel.design(text:"", font: .pretendard(size: 16, weight: .bold))
        priceLabel.design(text:"", font: .pretendard(size: 16, weight: .semiBold))
        
        starIcon.design(image: UIImage.star, contentMode: .scaleAspectFit)
        scoreLabel.design(text:"", textColor: .main, font: .pretendard(size: 14, weight: .semiBold))
        addressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 14, weight: .medium))
        
        checkImageView.design(image: UIImage.ImjangList.off, contentMode: .scaleAspectFit)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
