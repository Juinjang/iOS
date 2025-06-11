//
//  ImjangNoteTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/25/24.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class ImjangNoteTableViewCell: UITableViewCell {
    private let roomThumbnailImageView = UIImageView()
    private let roomNameLabel = UILabel()
    private let roomIcon = UIImageView()
    private let roomNameStackView = UIStackView()
    private let priceLabel = UILabel()
    private let starIcon = UIImageView()
    private let scoreLabel = UILabel()
    private let starStackView = UIStackView()
    private let addressLabel = UILabel()
    let bookMarkButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        configureHierarchy()
        configureLayout()
        configureView()
    }
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.frame = contentView.frame.inset(by: UIEdgeInsets(top: 0, left: 24, bottom: 8, right: 24))
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - configureCell
    func configureCell(imjangNote: MyImjangResponseDTO?) {
        guard let imjangNote else { return }
        
        roomNameLabel.text = imjangNote.name
        
        setPriceLabel(model: imjangNote)
       
        setScore(score: imjangNote.rate ?? "0.0")
        
        addressLabel.text = imjangNote.address
        
        let image = imjangNote.isScraped ? UIImage.ImjangList.bookmarkSelected : UIImage.ImjangList.bookmark
        bookMarkButton.setImage(image, for: .normal)
        
        let images = imjangNote.imageUrl
        if images.isEmpty {
            let image = UIImage.ImjangList.empty
            DispatchQueue.main.async {
                self.roomThumbnailImageView.image = image
            }
        } else {
            let image = images[0]
            if let url = URL(string: image) {
                DispatchQueue.main.async {
                    //                self.roomThumbnailImageView.image = UIImage(named: image)  // 임시
                    self.roomThumbnailImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
                }
            }
            
        }
    }
    
    // 가격 설정
    private func setPriceLabel(model: MyImjangResponseDTO) {
        if let monthlyRent = model.monthlyRent {
            priceLabel.text = "\(model.priceTypeString) \(monthlyRent.formatToKoreanCurrencyWithZero())"
        } else {
            priceLabel.text = "\(model.priceTypeString) \(model.price.formatToKoreanCurrencyWithZero())"
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
    
    private func configureHierarchy() {
        [roomThumbnailImageView, roomNameStackView, priceLabel, starStackView, addressLabel, bookMarkButton].forEach {
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
        roomThumbnailImageView.snp.makeConstraints {        // 방 썸네일 사진
            $0.leading.equalTo(contentView.snp.leading).offset(12)
            $0.centerY.equalTo(contentView)
            $0.size.equalTo(82)
        }
        
        roomNameStackView.snp.makeConstraints {
            $0.top.equalTo(contentView).offset(12)
            $0.leading.equalTo(roomThumbnailImageView.snp.trailing).offset(8)
            $0.trailing.lessThanOrEqualTo(contentView.snp.trailing).inset(12)
            $0.height.equalTo(24)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(roomNameStackView.snp.bottom).offset(1)
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.trailing.equalTo(contentView.snp.trailing).inset(12)
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
        
        bookMarkButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(contentView).inset(12)
            $0.size.equalTo(18)
        }
        
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.top.equalTo(starStackView.snp.bottom).offset(2)
            $0.trailing.equalTo(bookMarkButton.snp.leading).offset(-8)
        }
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(imjangNote: nil)
        self.roomThumbnailImageView.image = nil
        starIcon.image = nil
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
    
    private func configureView() {
        contentView.backgroundColor = .mainWhite
        
        roomThumbnailImageView.contentMode = .scaleAspectFill
        roomNameStackView.axis = .horizontal
        roomNameStackView.spacing = 4
        roomNameStackView.alignment = .center
        roomNameStackView.distribution = .fill
        
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.alignment = .fill
        starStackView.distribution = .fill

        
        roomIcon.design(image: UIImage.ImjangNote.house, contentMode: .scaleAspectFit)
        roomNameLabel.design(text:"", font: .pretendard(size: 16, weight: .bold))
        priceLabel.design(text:"", textColor: .gray450, font: .pretendard(size: 14, weight: .semiBold))
        
        starIcon.design(image: UIImage.starEmpty, contentMode: .scaleAspectFit)
        scoreLabel.design(text:"", textColor: .null, font: .pretendard(size: 14, weight: .semiBold))
        addressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 14, weight: .medium))
        
        bookMarkButton.design(image: UIImage.ImjangList.bookmark, backgroundColor: .clear)
    }
}
