//
//  ImjangPeriodView.swift
//  juinjang
//
//  Created by KimDongWoo on 5/5/25.
//

import UIKit
import Then
import SnapKit

final class ImjangPeriodView: BaseView {
    private let baseView = UIView().then {
        $0.backgroundColor = .gray200
        $0.roundCorners(cornerRadius: 15, corner: .all)
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontSize = 24
        $0.fontColor = .gray300
    }
    
    private let subContentLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
    }
    
    
    func configure(model: ImjangPeriodType,
                   isDoneEdit: Bool) {
        isDoneEdit
        ? (contentLabel.fontColor = .main)
        : (contentLabel.fontColor = .gray300)
        
        switch model {
        case .year(let string):
            contentLabel.text = string
            subContentLabel.text = "년"
        case .month(let string):
            contentLabel.text = string
            subContentLabel.text = "월"
        case .phase(let string):
            contentLabel.text = string
        }
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(baseView.with(contentLabel), subContentLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.left.equalToSuperview()
            $0.right.equalToSuperview().inset(19)
        }
        
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(8)
        }
        
        subContentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(baseView.snp.right).offset(5)
        }
    }
}
