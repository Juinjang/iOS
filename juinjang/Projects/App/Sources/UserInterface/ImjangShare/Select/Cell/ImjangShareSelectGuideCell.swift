//
//  ImjangShareSelectGuideCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import UIKit
import Then
import SnapKit

final class ImjangShareSelectGuideCell: BaseCollectionViewCell {
    private let containerView = UIView().then {
        $0.roundCorners(cornerRadius: 8, corner: .all)
        $0.backgroundColor = .bg
    }
    
    private let firstContentLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .gray500
        $0.fontAlignment = .left
        $0.text = "발로 뛴 임장, 리워드로 이어지다!"
    }
    
    private let secondContentLabel = DSLabel(.h3).then {
        $0.fontSize = 16
        $0.fontColor = .gray500
        $0.fontAlignment = .left
        $0.text = "임장노트 나누기 가이드"
    }
    
    private let guideIconView = UIImageView().then {
        $0.image = .shareGuide
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(
            containerView.with(
                firstContentLabel,
                secondContentLabel,
                guideIconView
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.height.equalTo(80)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        firstContentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalToSuperview().offset(18)
        }
        
        secondContentLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(16)
            $0.top.equalTo(firstContentLabel.snp.bottom).offset(2)
        }
        
        guideIconView.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
