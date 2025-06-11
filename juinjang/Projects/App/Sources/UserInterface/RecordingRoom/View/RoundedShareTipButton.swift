//
//  RoundedShareTipButton.swift
//  juinjang
//
//  Created by KimDongWoo on 5/28/25.
//

import UIKit
import Then
import SnapKit

final class RoundedShareTipButton: UIButton {
    private let infoIconView = UIImageView().then {
        $0.image = .infoCircle
    }
    
    private let mainTitleLabel = DSLabel(.body).then {
        $0.fontSize = 14
        $0.fontColor = .gray450
        $0.text = "공유 조건"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .gray100
        roundCorners(cornerRadius: 8, corner: .all)
        layer.borderWidth = 1
        layer.borderColor = UIColor.stroke.cgColor
    }
    
    private func configureHierarchy() {
        add(infoIconView, mainTitleLabel)
    }
    
    private func configureLayout() {
        infoIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(8)
            $0.size.equalTo(20)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(infoIconView.snp.right).offset(4)
        }
    }
}
