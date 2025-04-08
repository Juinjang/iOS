//
//  MyNoteAlertView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/7/25.
//

import UIKit
import Then
import SnapKit

final class MyNoteAlertView: BaseAlertViewController {
    private let titleLabel = UILabel().then {
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textColor = .gray600
        $0.textAlignment = .center
        $0.numberOfLines = 2
        $0.text = "좋아요를 취소할까요?\n'좋아한 노트' 목록에서 볼 수 없게 돼요."
    }
    
    init() {
        super.init(
            height: 234,
            contentViews: [
                titleLabel
            ],
            buttons: [
                .cancel(title: "아니요"),
                .confirm(title: "예")
            ]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(68)
            $0.centerX.equalToSuperview()
        }
    }
}
