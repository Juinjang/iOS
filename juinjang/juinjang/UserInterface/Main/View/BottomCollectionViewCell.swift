//
//  BottomCollectionViewCell.swift
//  Juinjang
//
//  Created by 박도연 on 12/31/23.
//

import UIKit
import SnapKit
import Then
import Kingfisher

final class BottomCollectionViewCell: UICollectionViewCell {
    var recentImjangImageView = UIImageView()
    
    var nameLabel = UILabel()
    var priceLabel = UILabel()
    var scoreStackView = UIStackView()
    var starIcon = UIImageView()
    var rateLabel = UILabel()
    
//MARK: - init
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
        recentImjangImageView.image = nil
        configureCell(listDto: nil)
    }
    
    func configureCell(listDto: LimjangDto?) {
        guard let listDto = listDto else { return }
        var priceType: String
        var price: String
        
        setImageUI(image: listDto.image)
        nameLabel.text = listDto.nickname
        
        switch listDto.priceType {
        case 0:
            priceType = "매매"
            price = formatRealEstatePrice(type: priceType, price: listDto.price)
        case 1:
            priceType = "전세"
            price = formatRealEstatePrice(type: priceType, price: listDto.price)
        case 2:
            priceType = "월세"
            price = formatRealEstatePrice(type: priceType, price: listDto.price)
        case 3:
            priceType = "실거래"
            price = formatRealEstatePrice(type: priceType, price: listDto.price)
        default:
            priceType = ""
            price = formatRealEstatePrice(type: priceType, price: listDto.price)
        }
        
        priceLabel.text = priceType.isEmpty ? "\(price)" : "\(priceType) \(price)"
        setScore(score: listDto.totalAverage)
    }
    
    private func formatRealEstatePrice(type: String, price: String) -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 1
        formatter.locale = Locale(identifier: "ko_KR")

        guard let priceValue = Int(price) else { return "\(price)" }

        if type == "매매" || type == "전세" || type == "" {
            if priceValue >= 100_000_000 { // 억 단위 이상
                let dividedPrice = Double(priceValue) / 100_000_000.0
                return "\(formatter.string(from: NSNumber(value: dividedPrice)) ?? "")억"
            } else if priceValue >= 1_000_000 { // 억 미만, 천 단위 표기
                let dividedPrice = Double(priceValue) / 1_000_000.0
                return "\(formatter.string(from: NSNumber(value: dividedPrice)) ?? "")만"
            } else { // 천 단위 미만은 그대로 표기
                return "\(price)"
            }
        }

        if type == "월세" {
            guard let priceValue = Int(price) else { return price }
            if priceValue >= 100_000 {
                let dividedPrice = priceValue / 10_000
                return "\(dividedPrice)" // 만 단위로 변환
            } else {
                return "\(priceValue / 1_000)" // 천 단위로 변환
            }
        }

        return "\(price)" // 기본은 숫자만 반환
    }
    
    private func setScore(score: String?) {
        guard let score, let doubleScore = Double(score) else {
            rateLabel.text = "0.0"
            setScoreStyle()
            return
        }
        
        let resultScore = doubleScore.truncateToSingleDecimal()
        rateLabel.text = String(format: "%.1f", resultScore)
        
        if resultScore == 0.0 {
            setScoreStyle()
        } else {
            setScoreStyle(empty: false)
        }
    }
    
    private func setScoreStyle(empty: Bool = true) {
        starIcon.image = empty ? ImageStyle.starEmpty : ImageStyle.star
        rateLabel.textColor = empty ? .null : .main
    }
    
    private func setImageUI(image: String?) {
        guard let imageURL = image else {
            recentImjangImageView.image = ImageStyle.emptyImage
            return
        }
        if let url = URL(string: imageURL) {
            recentImjangImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
        } else {
            recentImjangImageView.image = ImageStyle.gallery
        }
    }
    
    private func configureView() {
        
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = UIColor.stroke.cgColor
        contentView.backgroundColor = .mainWhite

        recentImjangImageView.design(cornerRadius: 10)
        recentImjangImageView.backgroundColor = .gray100
        nameLabel.design(font: .pretendard(size: 15, weight: .semiBold), numberOfLines: 2)
        priceLabel.design(textColor: .gray450, font: .pretendard(size: 14, weight: .medium))
        starIcon.design(image: ImageStyle.starEmpty, contentMode: .scaleAspectFit)
        rateLabel.design(text: "0.0", textColor: .null, font: .pretendard(size: 14, weight: .bold))
        scoreStackView.design(distribution: .fill, spacing: 3)
    }
    
    private func configureHierarchy() {
        [recentImjangImageView, nameLabel, priceLabel, scoreStackView].forEach {
            contentView.addSubview($0)
        }
        [starIcon, rateLabel].forEach {
            scoreStackView.addArrangedSubview($0)
        }
    }
        
    private func configureLayout() {
        recentImjangImageView.snp.makeConstraints{
            $0.top.equalToSuperview().offset(6)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(119)
        }
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(recentImjangImageView.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(35)
        }
        scoreStackView.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(11)
            $0.trailing.equalToSuperview().inset(11)
            $0.width.equalTo(42)
        }
        starIcon.snp.makeConstraints {
            $0.size.equalTo(15)
        }
        rateLabel.snp.makeConstraints {
            $0.height.equalTo(19)
        }
        priceLabel.snp.makeConstraints{
            $0.bottom.equalToSuperview().inset(12)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalTo(scoreStackView.snp.leading).offset(-6)
        }
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
    }

}
