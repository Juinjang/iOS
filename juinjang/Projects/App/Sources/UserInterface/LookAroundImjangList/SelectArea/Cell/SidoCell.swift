//
//  SidoCell.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit
import SnapKit

class SidoCell: BaseCollectionViewCell {
    let titleLabel = UILabel()
    
    func configureCell(title: String) {
        titleLabel.setAttributeString(text: title, color: .gray400, font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
    }
    
    override func configureHierarchy() {
        add(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview().inset(10)
        }
    }
}
