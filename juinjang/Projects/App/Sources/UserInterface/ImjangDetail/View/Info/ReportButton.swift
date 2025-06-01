//
//  ReportButton.swift
//  juinjang
//
//  Created by KimDongWoo on 5/31/25.
//

import UIKit
import Then
import SnapKit

final class ReportButton: UIButton {
    private let iconView = UIImageView().then {
        $0.image = .siren
    }
    
    private let mainTitleLabel = DSLabel(.body).then {
        $0.fontSize = 13
        $0.fontColor = .gray400
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        add(iconView, mainTitleLabel)
    }
    
    private func configureLayout() {
        iconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.size.equalTo(18)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconView.snp.right).offset(4)
        }
    }
}
