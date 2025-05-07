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
    
    private let textView = CountingTextView(
        maxLength: 500,
        placeholder: "[이런 메모를 추천드려요!]\n이 매물을 선택하신 특별한 이유가 있다면 알려주세요!\n매물을 보고 얻은 인사이트를 나눠주세요!"
    )
    
    func bind(relay: PublishRelay<String>) {
        textView.configure(relay: relay)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(titleLabel, textView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        textView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(248)
        }
    }
}
