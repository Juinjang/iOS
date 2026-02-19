//
//  TopFloatingButton.swift
//  juinjang
//
//  Created by KimDongWoo on 4/18/25.
//

import UIKit
import Then
import SnapKit

final class TopFloatingButton: UIButton {
    private let iconImageView = UIImageView().then {
        $0.image = .arrowTailUp
    }
    private let contentLabel = DSLabel(.title).then {
        $0.fontColor = .gray400
        $0.fontSize = 12
        $0.fontAlignment = .center
        $0.text = "TOP"
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .mainWhite
        roundCorners(cornerRadius: 24, corner: .all)
        layer.borderColor = UIColor.stroke3.cgColor
        layer.borderWidth = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.1
        layer.shadowOffset = CGSize(width: 0, height: 4)
        layer.shadowRadius = 4
        layer.masksToBounds = false
        clipsToBounds = false
    }
    
    private func configureHierarchy() {
        add(iconImageView, contentLabel)
    }
    
    private func configureLayout() {
        iconImageView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(10)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(10.31)
            $0.width.equalTo(12)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(iconImageView.snp.bottom).offset(1.69)
            $0.centerX.equalToSuperview()
            $0.width.equalTo(24)
            $0.height.equalTo(16)
        }
    }
}
