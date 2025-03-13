//
//  View+Extensions.swift
//  juinjang
//
//  Created by 조유진 on 12/31/23.
//

import UIKit

extension UIView {
    
    func applyGradientBackground() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds

        // TODO: 색상 변경
        gradientLayer.colors = [UIColor.mainWhite.cgColor, UIColor.gray200.cgColor]
        gradientLayer.locations = [0.0, 1.0]

        // 그레디언트 방향 설정 (위에서 아래로)
        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        // 뷰의 배경으로 그레디언트 레이어 추가
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func roundCorners(cornerRadius: CGFloat, corner: Corner) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = corner.cornerMasks
    }
}


enum Corner {
    case top
    case bottom
    case all
    
    var cornerMasks: CACornerMask {
        switch self {
        case .top: [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case .bottom: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .all: [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
    }
}
