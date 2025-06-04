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
        configureCell(imjangNote: nil)
        self.roomThumbnailImageView.image = nil
    }
}

// MARK: - Configure Cell
extension ImjangNoteCollectionViewCell {
    func configureCell(imjangNote: MyImjangResponseDTO?) {
        guard let imjangNote else { return }
        
        roomNameLabel.text = imjangNote.name
        
        setPriceLabel(model: imjangNote)
        
        setPyungAndFloor(model: imjangNote)
       
        setScore(score: imjangNote.rate)
        
        addressLabel.text = imjangNote.shortAddress
        
        let image = imjangNote.isScraped ? UIImage.ImjangList.bookmarkSelected : UIImage.ImjangList.bookmark
        bookMarkButton.setImage(image, for: .normal)
        
        DispatchQueue.main.async {
            self.roomThumbnailImageView.kf.setImage(
                with: URL(string: imjangNote.imageUrl.first ?? ""),
                placeholder: imjangNote.propertyTypeToHolderImage
            )
        }
    }
    
    // 가격 설정
    private func setPriceLabel(model: MyImjangResponseDTO) {
        priceLabel.text = (model.monthlyRent == nil)
        ? "\(model.priceTypeString) \(model.price.formatToKoreanCurrencyWithZero())"
        : "\(model.priceTypeString) \(model.monthlyRent?.formatToKoreanCurrencyWithZero() ?? "")"
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
    
    private func setPyungAndFloor(model: MyImjangResponseDTO) {
        if let pyung = model.pyong,
           let floor = model.floor {
            pyungAndFloorLabel.text = "\(pyung)평 \(floor)층"
        } else {
            pyungAndFloorLabel.text = "이 집의 평수와 층수를 알려주세요"
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
        [roomThumbnailImageView,
         roomNameStackView,
         priceLabel,
         pyungAndFloorLabel,
         addressLabel,
         starIcon,
         scoreLabel,
         bookMarkButton,
         baseLineView].forEach {
            contentView.addSubview($0)
        }
        [roomNameLabel, roomIcon].forEach {
            roomNameStackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        roomThumbnailImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(112)
            $0.width.equalTo(144)
        }
        
        roomNameStackView.snp.makeConstraints {
            $0.top.equalTo(roomThumbnailImageView.snp.top)
            $0.left.equalTo(roomThumbnailImageView.snp.right).offset(12)
            $0.height.equalTo(24)
        }
        
        roomIcon.snp.makeConstraints {
            $0.size.equalTo(16)
        }
        
        priceLabel.snp.makeConstraints {
            $0.top.equalTo(roomNameStackView.snp.bottom)
            $0.left.equalTo(roomThumbnailImageView.snp.right).offset(12)
            $0.height.equalTo(23)
        }
        
        pyungAndFloorLabel.snp.makeConstraints {
            $0.top.equalTo(priceLabel.snp.bottom)
            $0.height.equalTo(19)
            $0.left.equalTo(roomThumbnailImageView.snp.right).offset(12)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(pyungAndFloorLabel.snp.bottom)
            $0.left.equalTo(roomThumbnailImageView.snp.right).offset(12)
            $0.height.equalTo(19)
        }
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.centerY.equalTo(scoreLabel.snp.centerY).offset(-1)
            $0.left.equalTo(roomThumbnailImageView.snp.right).offset(12)
        }
        
        scoreLabel.snp.makeConstraints {
            $0.height.equalTo(20)
            $0.bottom.equalTo(roomThumbnailImageView.snp.bottom).offset(-2)
            $0.left.equalTo(starIcon.snp.right).offset(4)
        }
        
        bookMarkButton.snp.makeConstraints {
            $0.bottom.trailing.equalTo(contentView).inset(24)
            $0.size.equalTo(18)
        }
        
        baseLineView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(12)
        }
    }
    
    override func draw(_ rect: CGRect) {
        roomThumbnailImageView.layer.cornerRadius = 5
        roomThumbnailImageView.clipsToBounds = true
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
        starStackView.alignment = .center
        starStackView.distribution = .fill

        
        roomIcon.design(image: UIImage.ImjangNote.house, contentMode: .scaleAspectFit)
        roomNameLabel.design(text:"", font: .pretendard(size: 16, weight: .bold))
        priceLabel.design(text:"", font: .pretendard(size: 16, weight: .semiBold))
        
        starIcon.design(image: UIImage.star, contentMode: .scaleAspectFit)
        scoreLabel.design(text:"", textColor: .main, font: .pretendard(size: 14, weight: .semiBold))
        addressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 14, weight: .medium))
        
        bookMarkButton.design(image: UIImage.ImjangList.bookmark, backgroundColor: .clear)
    }
}
