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

class BottomCollectionViewCell: UICollectionViewCell {
    var recentImjangImageView = UIImageView()
    var noImageImageView = UIImageView()
    
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
        setImageUI(image: listDto.image)
        nameLabel.text = listDto.nickname
        priceLabel.text = listDto.price.formatToKoreanCurrencyWithZero()
        setRate(totalAverage: listDto.totalAverage)
    }
    
    func setRate(totalAverage: String?) {
        if let totalAverage {
            starIcon.image = ImageStyle.star
            rateLabel.text = totalAverage
        } else {
            starIcon.image = ImageStyle.starEmpty
            rateLabel.text = "0.0"
        }
    }
    
    func setImageUI(image: String?) {
        if let image = image {
            noImageImageView.isHidden = true
            if let url = URL(string: image) {
                recentImjangImageView.kf.setImage(with: url, placeholder: UIImage(named: "1"))
            } else {
                recentImjangImageView.image = UIImage(named: "1")
            }
        } else {
            noImageImageView.isHidden = false
        }
    }
    
    func configureView() {
        contentView.layer.cornerRadius = 10
        contentView.clipsToBounds = true
        contentView.layer.borderWidth = 1.5
        contentView.layer.borderColor = ColorStyle.gray4.cgColor
        contentView.backgroundColor = .white

        recentImjangImageView.design(cornerRadius: 10)
        recentImjangImageView.backgroundColor = ColorStyle.gray0
        noImageImageView.design(image: ImageStyle.gallery)
        nameLabel.design(font: .pretendard(size: 15, weight: .semiBold), numberOfLines: 2)
        priceLabel.design(textColor: ColorStyle.priceColor, font: .pretendard(size: 14, weight: .bold))
        starIcon.design(image: ImageStyle.starEmpty, contentMode: .scaleAspectFit)
        rateLabel.design(text: "0.0", textColor: ColorStyle.null, font: .pretendard(size: 14, weight: .bold))
        scoreStackView.design(distribution: .fill, spacing: 3)
    }
    
    private func configureHierarchy() {
        [recentImjangImageView, nameLabel, priceLabel, scoreStackView].forEach {
            contentView.addSubview($0)
        }
        recentImjangImageView.addSubview(noImageImageView)
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
        noImageImageView.snp.makeConstraints{
            $0.center.equalTo(recentImjangImageView)
            $0.size.equalTo(48)
        }
        nameLabel.snp.makeConstraints{
            $0.top.equalTo(recentImjangImageView.snp.bottom).offset(6)
            $0.horizontalEdges.equalToSuperview().inset(8)
            $0.height.equalTo(35)
        }
        scoreStackView.snp.makeConstraints{
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
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
            $0.top.equalTo(nameLabel.snp.bottom).offset(9)
            $0.leading.equalToSuperview().inset(8)
            $0.trailing.equalTo(scoreStackView.snp.leading).offset(-6)
        }
        priceLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}
