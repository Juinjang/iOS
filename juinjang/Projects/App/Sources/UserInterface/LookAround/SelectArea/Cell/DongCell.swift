//
//  DongCell.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class DongCell: BaseCollectionViewCell {
    private var titleLabel = DSLabel(.body).then {
        $0.fontSize = 14
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let checkImageView = UIImageView().then {
        $0.image = .ImjangList.on
        $0.isHidden = true
    }
    
    func configureCell(item: DongCellItem) {
        titleLabel.text = item.name
        titleLabel.fontColor = item.isSelected ? .main : .gray400
        titleLabel.fontWeight = item.isSelected ? .semiBold : .medium
        checkImageView.isHidden = !item.isSelected
        updateIsSelectedLayout(isSelected: item.isSelected)
    }
    
    private func updateIsSelectedLayout(isSelected: Bool) {
        if isSelected {
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.trailing.lessThanOrEqualTo(checkImageView.snp.leading).offset(-16)
                make.verticalEdges.equalToSuperview().inset(10)
            }
        } else {
            titleLabel.snp.remakeConstraints { make in
                make.leading.equalToSuperview().inset(16)
                make.trailing.equalToSuperview().inset(16)
                make.verticalEdges.equalToSuperview().inset(10)
            }
        }
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        checkImageView.isHidden = true
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
            make.trailing.equalToSuperview().inset(16)
            make.verticalEdges.equalToSuperview().inset(10)
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
