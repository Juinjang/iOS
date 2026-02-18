//
//  ReportImjangListTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 1/25/24.
//

import UIKit
import SnapKit

final class ReportImjangListTableViewCell: UITableViewCell {
    let roomThumbnailImageView = UIImageView()
    let roomNameLabel = UILabel()
    let roomIcon = UIImageView()
    let roomNameStackView = UIStackView()
    let priceLabel = UILabel()
    let starIcon = UIImageView()
    let scoreLabel = UILabel()
    let starStackView = UIStackView()
    let addressLabel = UILabel()
    var isSelect: Bool = false
   
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        [roomThumbnailImageView, roomNameStackView, priceLabel, starStackView, addressLabel, ].forEach {
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
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setPriceLabel(priceList: [String?], priceType: String) {
        switch priceList.count {
            
        case 1:
            guard
                let raw = priceList.first ?? nil,
                let value = Int(raw),
                value > 0
            else {
                priceLabel.text = "가격 미입력"
                return
            }

            let formatted = raw.formatToKoreanCurrencyWithZero()
            priceLabel.text = priceType.isEmpty
                ? formatted
                : "\(priceType) \(formatted)"
            
        case 2:
            guard
                let depositRaw = priceList[safe: 0] ?? nil,
                let rentRaw = priceList[safe: 1] ?? nil,
                let rentValue = Int(rentRaw),
                rentValue > 0
            else {
                priceLabel.text = "가격 미입력"
                return
            }

            let formattedDeposit = depositRaw.formatToKoreanCurrencyWithZero()
            let formattedRent = rentRaw.oneSplitAmount().addingCommas()

            priceLabel.text = "\(priceType) \(formattedDeposit) / \(formattedRent)"
            
        default:
            priceLabel.text = "편집을 통해 가격을 설정해주세요."
        }
    }
    
    func configureCell(imjangNote: ListDto?) {
        guard let imjangNote else { return }
        
        roomNameLabel.text = imjangNote.nickname
        let priceTypeString: String
        switch imjangNote.priceType {
        case 0:
            priceTypeString = "매매"
        case 1:
            priceTypeString = "전세"
        case 2:
            priceTypeString = "월세"
        case 3:
            priceTypeString = "실거래가"
        default:
            priceTypeString = ""
        }
        setPriceLabel(priceList: imjangNote.priceList, priceType: priceTypeString)
        setRate(totalAverage: imjangNote.totalAverage)
        
        addressLabel.text = imjangNote.address
        
        let images = imjangNote.images
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
    
    func setRate(totalAverage: String?) {
        if let totalAverage = totalAverage, let average = Double(totalAverage) {
            // 소수점 두 자리까지 포맷팅
            let formattedAverage = String(format: "%.2f", average)
            starIcon.image = UIImage.star
            scoreLabel.text = formattedAverage
        } else {
            starIcon.image = UIImage.starEmpty
            scoreLabel.text = "0.0"
        }
    }
    
    func setConstraints() {
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
            $0.top.equalTo(roomNameStackView.snp.bottom)
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
        addressLabel.snp.makeConstraints {
            $0.leading.equalTo(roomNameLabel.snp.leading)
            $0.top.equalTo(starStackView.snp.bottom)
           // $0.trailing.greaterThanOrEqualTo(bookMarkButton.snp.leading).inset(8)
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        configureCell(imjangNote: nil)
        self.roomThumbnailImageView.image = nil
    }
    
    override func draw(_ rect: CGRect) {
        contentView.clipsToBounds = true
        contentView.layer.cornerRadius = 10
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.stroke.cgColor
//        roomThumbnailImageView.design(contentMode: .scaleAspectFill, cornerRadius: 5)
        DispatchQueue.main.async {
            self.roomThumbnailImageView.layer.cornerRadius = 5
            self.roomThumbnailImageView.clipsToBounds = true
        }
    }
    
    func designView() {
        roomNameStackView.axis = .horizontal
        roomNameStackView.spacing = 4
        roomNameStackView.alignment = .center
        roomNameStackView.distribution = .fill
        
        starStackView.axis = .horizontal
        starStackView.spacing = 4
        starStackView.alignment = .center
        starStackView.distribution = .fill

        roomThumbnailImageView.contentMode = .scaleAspectFill
        roomIcon.design(image: UIImage.ImjangNote.house, contentMode: .scaleAspectFit)
        roomNameLabel.design(text:"", font: .pretendard(size: 16, weight: .bold))
        priceLabel.design(text:"", font: .pretendard(size: 16, weight: .semiBold))
        
        starIcon.design(image: UIImage.star, contentMode: .scaleAspectFit)
        scoreLabel.design(text:"0.0", textColor: .main, font: .pretendard(size: 14, weight: .semiBold))
        addressLabel.design(text: "", textColor: .gray400, font: .pretendard(size: 14, weight: .medium))
    }
}
