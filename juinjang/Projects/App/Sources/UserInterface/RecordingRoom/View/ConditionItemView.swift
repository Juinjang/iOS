//
//  ConditionItemView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/27/25.
//

import UIKit
import Then
import SnapKit

final class ConditionItemView: BaseView {
    private let checkIconView = UIImageView()
    
    private let titleLabel = DSLabel(.title).then {
        $0.fontColor = .gray450
        $0.fontSize = 14
    }
    
    private let contentLabel = DSLabel(.reguler).then {
        $0.fontColor = .gray400
        $0.fontSize = 12
        $0.fontAlignment = .center
    }
    
    func configure(model: ShareableCondition) {
        titleLabel.text = model.categoryToKorean
        contentLabel.text = "\(model.answeredCount)/\(model.totalCount)"
        checkIconView.image = (model.answeredCount >= model.requiredCount) ? .checkMain : .checkGray
    }
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(checkIconView, titleLabel, contentLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        checkIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        titleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(checkIconView.snp.right).offset(2)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(titleLabel.snp.right).offset(5)
            $0.right.equalToSuperview()
        }
    }
}
