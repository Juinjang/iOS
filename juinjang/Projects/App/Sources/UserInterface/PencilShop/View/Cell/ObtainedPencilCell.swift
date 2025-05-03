//
//  ObtainedPencilCell.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit
import SnapKit

final class ObtainedPencilCell: BaseCollectionViewCell {
    private let dateLabel = UILabel()
    private let textLabel = UILabel()
    private let pencilCountLabel = UILabel()
    private let pencilImageView = UIImageView().then {
        $0.image = .ImjangList.pencilGray
        $0.contentMode = .scaleAspectFit
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        pencilImageView.image = nil
    }
    
    func configureCell(obtainedPencil: ObtainedPencilModel) {
        dateLabel.setAttribute(
            text: String.dateToString(target: obtainedPencil.createdAt),
            color: .gray300,
            font: .pretendard(size: 12, weight: .regular),
            lineHeight: 16,
            charSpacing: -0.02
        )
        textLabel.setAttribute(
            text: obtainedPencil.content,
            color: .gray600,
            font: .pretendard(size: 14, weight: .medium),
            lineHeight: 20,
            charSpacing: -0.02
        )
        pencilCountLabel.setAttribute(
            text: "+\(obtainedPencil.acquiredQuantity)",
            color:  obtainedPencil.isRead ? .main : .gray450,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            charSpacing: -0.02
        )
        pencilImageView.image =  obtainedPencil.isRead ? .ImjangList.pencil : .ImjangList.pencilGray
        
        contentView.backgroundColor = obtainedPencil.isRead ? .white : .gray100
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(
            dateLabel,
            textLabel,
            pencilImageView,
            pencilCountLabel
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(16)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom)
            make.leading.equalTo(dateLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
        }
        
        pencilImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalToSuperview()
            make.size.equalTo(20)
        }
        
        pencilCountLabel.snp.makeConstraints { make in
            make.trailing.equalTo(pencilImageView.snp.leading)
            make.centerY.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
