//
//  ImjangSkeletonCollectionViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/5/25.
//

import UIKit

public final class ImjangSkeletonCollectionViewCell: UICollectionViewCell {
    private let roomImageView = UIImageView()
    private let nameLabel = UILabel()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(roomImageView)
        contentView.addSubview(nameLabel)
    }
    
    private func configureLayout() {
        roomImageView.snp.makeConstraints {        // 방 썸네일 사진
            $0.leading.equalTo(contentView.snp.leading)
            $0.centerY.equalTo(contentView)
            $0.width.equalTo(144)
            $0.height.equalTo(112)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(roomImageView.snp.top)
            $0.leading.equalTo(roomImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(contentView)
        }
    }
    
    private func configureView() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        roomImageView.isSkeletonable = true
        roomImageView.skeletonCornerRadius = 6
        
        nameLabel.isSkeletonable = true
        nameLabel.linesCornerRadius = 4
        nameLabel.lastLineFillPercent = 50
        nameLabel.skeletonTextNumberOfLines = 3
        nameLabel.skeletonTextLineHeight = .fixed(15)
    }
}
