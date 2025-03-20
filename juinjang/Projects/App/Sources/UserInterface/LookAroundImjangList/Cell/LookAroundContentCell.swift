//
//  LookAroundContentCell.swift
//  juinjang
//
//  Created by 조유진 on 3/1/25.
//

import UIKit

final class LookAroundContentCell: BaseCollectionViewCell {
    private let iconImageView = UIImageView().then {
        $0.image = nil
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
    }
    
    func configureCell(content: LookAroundContent) {
        iconImageView.image = content.iconImage
        titleLabel.setAttributeString(text: content.title, color: .gray600, font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
    }
    
    override func configureHierarchy() {
        [iconImageView, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        layer.masksToBounds = false
        layer.cornerRadius = 8
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        backgroundColor = .gray100
    }
}
