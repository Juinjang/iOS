//
//  SigunguCell.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class SigunguCell: BaseCollectionViewCell {
    private var titleLabel = DSLabel(.body)
    
    func configureCell(item: SigunguCellItem) {
        titleLabel.text = item.name
        titleLabel.fontColor = item.isSelected ? .main : .gray400
        titleLabel.fontWeight = item.isSelected ? .semiBold : .medium
        contentView.backgroundColor = item.isSelected ? .main100 : .mainWhite
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.addSubview(titleLabel)
    }
     
    override func configureLayout() {
        super.configureLayout()
        titleLabel.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
