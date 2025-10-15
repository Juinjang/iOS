//
//  SubwayAnswerView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/17/25.
//

import UIKit
import Then
import SnapKit

final class SubwayAnswerView: BaseView {
    private let iconImageView = UIImageView()
    
    private let textLabel = DSLabel(.reguler).then {
        $0.fontSize = 16
        $0.fontColor = .gray450
    }
    
    func configure(for model: Option) {
        iconImageView.image = UIImage(data: model.image)
        textLabel.text = "\(model.option)"
    }
    
    override func configureView() {
        backgroundColor = .main100
        roundCorners(cornerRadius: 15.5, corner: .all)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(iconImageView, textLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        iconImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(12)
            $0.size.equalTo(16)
        }
        
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconImageView.snp.right).offset(7)
        }
    }
}
