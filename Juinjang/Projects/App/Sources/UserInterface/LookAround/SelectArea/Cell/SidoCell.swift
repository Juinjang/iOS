//
//  SidoCell.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit
import SnapKit
import Then

final class SidoCell: BaseCollectionViewCell {
    private var titleLabel = DSLabel(.body).then {
        $0.fontSize = 14
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        contentView.backgroundColor = .white
    }
    
    func configureCell(item: SidoCellItem) {
        titleLabel.text = item.name.provinceAbbr
        titleLabel.fontWeight = item.isSelected ? .semiBold : .medium
        titleLabel.fontColor = item.isSelected ? .white : .gray400
        contentView.backgroundColor = item.isSelected ? .main : .white
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(titleLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
}
