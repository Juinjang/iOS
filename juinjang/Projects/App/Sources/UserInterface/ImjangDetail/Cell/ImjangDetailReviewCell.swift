//
//  ImjangDetailReviewCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

import UIKit
import Then
import SnapKit

final class ImjangDetailReviewCell: BaseCollectionViewCell {
    private let grayBackgroundView = UIView().then {
        $0.backgroundColor = .gray100
    }
    
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "임장 상세 후기"
    }
    
    private let starRateView = StarRateView()
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontColor = .gray600
        $0.numberOfLines = 100
    }
    
    func bind(_ model: ImjangDetailReviewModel) {
        starRateView.configure(for: model.rate)
        contentLabel.text = model.review
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(
            grayBackgroundView,
            titleLabel,
            starRateView,
            contentLabel
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        grayBackgroundView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.height.equalTo(12)
            $0.horizontalEdges.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(grayBackgroundView.snp.bottom).offset(32)
            $0.left.equalToSuperview().offset(24)
        }
        
        starRateView.snp.makeConstraints {
            $0.left.equalTo(titleLabel.snp.right).offset(8)
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.width.equalTo(100)
            $0.height.equalTo(20)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
