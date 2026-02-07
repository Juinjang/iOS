//
//  StarRateView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/18/25.
//

import UIKit
import Then
import SnapKit

final class StarRateView: BaseView {
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fillEqually
    }
    
    func configure(for score: Double) {
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let rounded = (score * 2).rounded() / 2 // 4.3 → 4.5
        let fullStars = Int(rounded)
        let hasHalfStar = rounded - Double(fullStars) == 0.5
        let totalStars = 5
        
        for i in 0..<totalStars {
            let imageView = UIImageView()
            if i < fullStars {
                imageView.image = UIImage.starRateFull
            } else if i == fullStars && hasHalfStar {
                imageView.image = UIImage.starRateHalf
            } else {
                imageView.image = UIImage.starRateNone
            }
            imageView.contentMode = .scaleAspectFit
            imageView.snp.makeConstraints {
                $0.size.equalTo(20)
            }
            stackView.addArrangedSubview(imageView)
        }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(stackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
