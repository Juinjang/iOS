//
//  TextAnswerView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/18/25.
//

import UIKit
import Then
import SnapKit

final class TextAnswerView: BaseView {
    private let label = DSLabel(.reguler).then {
        $0.fontAlignment = .center
        $0.fontColor = .gray450
        $0.fontSize = 16
    }
    
    func configure(for text: String) {
        label.text = text
    }
    
    override func configureView() {
        backgroundColor = .main100
        roundCorners(cornerRadius: 15.5, corner: .all)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(label)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        label.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(12)
            $0.center.equalToSuperview()
        }
    }
}
