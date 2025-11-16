//
//  RecordFileSkeletonTableViewCell.swift
//  juinjang
//
//  Created by 조유진 on 2/5/25.
//

import UIKit

public final class RecordFileSkeletonTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let playImageView = UIImageView()

    public override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        contentView.addSubview(playImageView)
        contentView.addSubview(nameLabel)
    }
    
    private func configureLayout() {
        nameLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().offset(24)
            $0.trailing.equalTo(playImageView.snp.leading).offset(-12)
        }
        
        playImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(24)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(24)
        }
    }
    
    private func configureView() {
        isSkeletonable = true
        contentView.isSkeletonable = true
        playImageView.isSkeletonable = true
        playImageView.skeletonCornerRadius = 10
        
        nameLabel.isSkeletonable = true
        nameLabel.linesCornerRadius = 4
        nameLabel.skeletonTextLineHeight = .fixed(15)
    }
}
