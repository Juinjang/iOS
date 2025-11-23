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
    
    private let tipBaseView = UIView().then {
        $0.backgroundColor = .gray100
        $0.roundCorners(cornerRadius: 10, corner: .all)
    }
    
    private let tipTitleLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .gray400
        $0.text = "Tip. 공유한 임장노트는 수정할 수 없어요"
        $0.fontAlignment = .left
    }
    
    private let tipContentLabel = DSLabel(.reguler).then {
        $0.fontSize = 12
        $0.fontColor = .gray400
        $0.text = "모든 사용자는 공유된 정보를 참고하여 임장을 검토하고 구매를 결정하게 됩니다. 정보의 신뢰성과 일관성을 위해 공유한 임장노트는 수정할 수 없어요. 신중하게 작성해주세요!"
        $0.numberOfLines = 3
        $0.fontAlignment = .left
        $0.setLineHeight(16.2)
    }
    
    func bind(relay: PublishRelay<String>) {
        textView.configure(relay: relay)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(
            titleLabel,
            textView,
            tipBaseView.with(
                tipTitleLabel,
                tipContentLabel
            )
        )
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
        
        tipBaseView.snp.makeConstraints {
            $0.top.equalTo(textView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(95)
        }
        
        tipTitleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
        
        tipContentLabel.snp.makeConstraints {
            $0.top.equalTo(tipTitleLabel.snp.bottom).offset(4)
            $0.horizontalEdges.equalToSuperview().inset(14)
        }
    }
}
