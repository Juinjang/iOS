//
//  UsedPencilCell.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit
import SnapKit

final class UsedPencilCell: BaseCollectionViewCell {
    private let dateLabel = UILabel()
    private let purchasedLabel = PaddingLabel(padding: UIEdgeInsets(top: 0, left: 4, bottom: 0, right: 4)).then {
        $0.backgroundColor = .point.withAlphaComponent(0.1)
        $0.setAttribute(text: "소장", color: .point, font: .pretendard(size: 12, weight: .medium), lineHeight: 17, alignment: .center)
        $0.roundCorners(cornerRadius: 4, corner: .all)
    }
    
    private let textLabel = UILabel()
    private let remainingPencilLabel = UILabel()
    private let usedPencilCountLabel = UILabel()
    private let pencilImageView = UIImageView().then {
        $0.image = .ImjangList.pencil
        $0.contentMode = .scaleAspectFit
    }
    private let dashedBorder = CAShapeLayer()
  
    override func prepareForReuse() {
        super.prepareForReuse()
        dashedBorder.removeFromSuperlayer()
    }
    
    func configureCell(usedPencil: UsedPencilDTO) {
        dateLabel.setAttribute(
            text: String.dateToString(target: usedPencil.createdAt),
            color: .gray300,
            font: .pretendard(size: 14, weight: .medium),
            lineHeight: 20,
            charSpacing: -0.02
        )
        textLabel.setAttribute(
            text: "임장노트 [\(usedPencil.buildingName)]",
            color: .gray600,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            charSpacing: -0.02
        )
        remainingPencilLabel.setAttribute(
            text: "남은 연필 \(usedPencil.remainQuantity)개",
            color: .gray400,
            font: .pretendard(size: 14, weight: .medium),
            lineHeight: 20,
            charSpacing: -0.02
        )
        
        usedPencilCountLabel.setAttribute(
            text: "-\(usedPencil.useQuantity)",
            color: .gray600,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            charSpacing: -0.02
        )
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(
            dateLabel,
            purchasedLabel,
            textLabel,
            remainingPencilLabel,
            usedPencilCountLabel,
            pencilImageView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        dateLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(16)
        }
        
        purchasedLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalTo(textLabel)
        }
        
        textLabel.snp.makeConstraints { make in
            make.top.equalTo(dateLabel.snp.bottom).offset(21)
            make.leading.equalTo(purchasedLabel.snp.trailing).offset(4)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.height.equalTo(23)
        }
        
        remainingPencilLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        usedPencilCountLabel.snp.makeConstraints { make in
            make.top.equalTo(remainingPencilLabel.snp.bottom).offset(21)
            make.trailing.equalTo(pencilImageView.snp.leading)
            make.height.equalTo(23)
        }
        
        pencilImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(usedPencilCountLabel)
            make.size.equalTo(20)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        addDashedBottomBorder()
    }
    
    private func addDashedBottomBorder() {
        dashedBorder.strokeColor = UIColor.stroke.cgColor
        dashedBorder.lineDashPattern = [4, 4]
        dashedBorder.lineWidth = 1.0

        let path = CGMutablePath()
        let startPoint = CGPoint(x: 0, y: bounds.height - 1)
        let endPoint = CGPoint(x: bounds.width, y: bounds.height - 1)
        path.addLines(between: [startPoint, endPoint])
      
        dashedBorder.path = path
        dashedBorder.frame = bounds

        layer.addSublayer(dashedBorder)
    }
}
