//
//  StarRateLabel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/18/25.
//

import UIKit
import Then
import SnapKit

final class MyNoteStarRateLabel: BaseView {
    private let starIcon = UIImageView().then {
        $0.image = .starRounded
        $0.contentMode = .scaleAspectFit
    }
    
    private let label = TitleLabel().then {
        $0.fontSize = 13
        $0.fontColor = .mainWhite
        $0.lineHeight = 18.85
        $0.letterSpacing = -0.2
    }
    
    var rateNumber: Double = 0.0 {
        didSet {
            label.text = "\(rateNumber)"
        }
    }
    
    override func configureView() {
        super.configureView()
        layer.cornerRadius = 2
        layer.masksToBounds = true
        backgroundColor = .gray450.withAlphaComponent(0.7)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add([starIcon, label])
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        starIcon.snp.makeConstraints {
            $0.size.equalTo(14)
            $0.left.equalToSuperview().offset(2)
            $0.centerY.equalToSuperview()
        }
        
        label.snp.makeConstraints {
            $0.left.equalTo(starIcon.snp.right).offset(2)
            $0.centerY.equalToSuperview()
        }
    }
    
    func reset() {
        rateNumber = 0.0
    }
}
