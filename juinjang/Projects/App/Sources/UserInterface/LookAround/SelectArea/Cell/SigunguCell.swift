//
//  SigunguCell.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class SigunguCell: BaseCollectionViewCell {
    private var titleLabel = DSLabel(.body)
    
    private let checkImageView = UIImageView().then {
        $0.image = .ImjangList.on
        $0.isHidden = true
    }
    
    func configureCell(item: SigunguCellItem) {
        titleLabel.text = item.name
        titleLabel.fontColor = item.isSelected ? .white : .gray400
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubview(titleLabel)
        addSubview(checkImageView)
    }
     
    override func configureLayout() {
        super.configureLayout()
        titleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.trailing.lessThanOrEqualTo(checkImageView.snp.leading).offset(-4)
            make.centerY.equalToSuperview()
            make.verticalEdges.lessThanOrEqualToSuperview().inset(10)
        }
        
        checkImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
