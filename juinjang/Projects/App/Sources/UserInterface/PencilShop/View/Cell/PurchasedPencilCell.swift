//
//  PurchasedPencilCell.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit
import SnapKit

final class PurchasedPencilCell: BaseCollectionViewCell {
    private let dateLabel = UILabel()
    private let textLabel = UILabel()
    private let remainingPencilLabel = UILabel()
    private let priceLabel = UILabel()
    private let dashedBorder = CAShapeLayer()
  
    override func prepareForReuse() {
        super.prepareForReuse()
        dashedBorder.removeFromSuperlayer()
    }
    
    func configureCell(purchasedPencil: PurchasedPencilModel) {
        dateLabel.setAttribute(
            text: String.dateToString(target: purchasedPencil.createdAt),
            color: .gray300,
            font: .pretendard(size: 14, weight: .medium),
            lineHeight: 20,
            charSpacing: -0.02
        )
        textLabel.setAttribute(
            text: purchasedPencil.title,
            color: .gray600,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            charSpacing: -0.02
        )
        remainingPencilLabel.setAttribute(
            text: "남은 연필 \(purchasedPencil.remainQuantity)개",
            color: .gray400,
            font: .pretendard(size: 14, weight: .medium),
            lineHeight: 20,
            charSpacing: -0.02
        )
        
        priceLabel.setAttribute(
            text: "\(purchasedPencil.price)원",
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
            textLabel,
            remainingPencilLabel,
            priceLabel
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
            make.top.equalTo(dateLabel.snp.bottom).offset(21)
            make.leading.equalTo(dateLabel)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
            make.height.equalTo(23)
        }
        
        remainingPencilLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.trailing.equalToSuperview().inset(24)
            make.height.equalTo(20)
        }
        
        priceLabel.snp.makeConstraints { make in
            make.top.equalTo(remainingPencilLabel.snp.bottom).offset(21)
            make.trailing.equalTo(remainingPencilLabel)
            make.height.equalTo(23)
            make.bottom.lessThanOrEqualToSuperview().offset(-12)
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
