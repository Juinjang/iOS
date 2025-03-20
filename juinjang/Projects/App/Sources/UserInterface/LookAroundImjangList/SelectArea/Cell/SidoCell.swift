//
//  SidoCell.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class SidoCell: BaseCollectionViewCell {
    private let titleLabel = UILabel()
    
    func configureCell(title: String) {
        titleLabel.setAttributeString(text: title, color: .mainWhite, font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
    }
    
    override func configureHierarchy() {
        addSubview(titleLabel)
    }
    
    override func configureLayout() {
        titleLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
