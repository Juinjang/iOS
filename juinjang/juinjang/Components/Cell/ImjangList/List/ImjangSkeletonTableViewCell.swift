//
//  ImjangSkeletonTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/5/25.
//

import UIKit

final class ImjangSkeletonTableViewCell: UITableViewCell {
    private let roomImageView = UIImageView()
    private let nameLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
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
            $0.leading.equalTo(contentView.snp.leading).offset(30)
            $0.centerY.equalTo(contentView)
            $0.size.equalTo(72)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(roomImageView.snp.top)
            $0.leading.equalTo(roomImageView.snp.trailing).offset(8)
            $0.trailing.equalTo(contentView).inset(30)
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
