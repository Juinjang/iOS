//
//  ShareWriteReviewCell.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay
import RxCocoa

final class ShareWriteReviewCell: BaseCollectionViewCell {
    private let titleLabel = DSLabel(.h3).then {
        $0.fontColor = .gray600
        $0.text = "임장 상세 후기"
        $0.fontAlignment = .left
    }
    
    func bind(relay: PublishRelay<String>) {
        
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(titleLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
    }
}
