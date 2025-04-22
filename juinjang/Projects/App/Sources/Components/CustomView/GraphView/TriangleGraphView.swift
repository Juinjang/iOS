//
//  TriangleGraphView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/15/25.
//

import UIKit
import Then
import SnapKit

struct TriangleGraphModel {
    let rates: [Double]
    var fillColor: UIColor = .mainWhite
    var cornerRadius: CGFloat = 1.5
    var isGradient: Bool = false
    var gradientColors: [CGColor] = [
        UIColor.mainGradient1.cgColor,
        UIColor.mainGradient2.cgColor
    ]
}

final class TriangleGraphView: BaseView {
    private let baseTriangleView = UIImageView().then {
        $0.image = .graph
        $0.contentMode = .scaleAspectFit
    }
    
    private var rateTriangleViews: [RateTriangleView] = []

    func configure(for models: [TriangleGraphModel]) {
        rateTriangleViews.forEach { $0.removeFromSuperview() }
        rateTriangleViews = []
        
        models.reversed().forEach { model in
            let triangleView = RateTriangleView()
            baseTriangleView.addSubview(triangleView)
            rateTriangleViews.append(triangleView)
            
            triangleView.snp.makeConstraints {
                $0.centerX.equalTo(baseTriangleView.snp.centerX)
                $0.centerY.equalTo(baseTriangleView.snp.centerY).offset(-4)
                $0.size.equalTo(205)
            }
            triangleView.configure(for: model)
        }
    }
    
    override func configureView() {
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubview(baseTriangleView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseTriangleView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(40)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(237)
        }
    }
}
