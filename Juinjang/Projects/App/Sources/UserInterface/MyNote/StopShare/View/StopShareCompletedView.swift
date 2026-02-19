//
//  StopShareCompletedView.swift
//  juinjang
//
//  Created by KimDongWoo on 6/13/25.
//

import UIKit
import SnapKit
import Then

final class StopShareCompletedView: BaseAlertViewController {
    private let titleLabel = DSLabel(.body).then {
        $0.fontColor = .gray600
        $0.text = "선택한 노트의 공유가 중단되었습니다"
    }
    
    init() {
        super.init(
            height: 202,
            contentViews: [titleLabel],
            buttons: [.confirm(title: "확인")]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(66)
            $0.centerX.equalToSuperview()
        }
    }
}
