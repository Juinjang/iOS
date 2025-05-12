//
//  GradientCheckCountView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/13/25.
//

import UIKit
import Then
import SnapKit

final class GradientCheckCountView: BaseView {
    private let gradientLayer = CAGradientLayer()
    
    private let checkBaseView = UIView()
    
    private let checkIconView = UIImageView().then {
        $0.image = .CheckList.checkedButtonWhite
    }
    
    private let checkContentLabel = DSLabel(.body2).then {
        $0.fontColor = .mainWhite
    }
    
    func configure(for model: ImjangDetailInfoModel) {
        checkContentLabel.text = "\(model.checkedCount)항목 체크됨"
    }
        
    override func configureView() {
        super.configureView()
        
        gradientLayer.colors = [
            UIColor.mainGradient1.cgColor,
            UIColor.mainGradient2.cgColor
        ]
        
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 1.0)

        gradientLayer.locations = [0.0, 1.0]

        layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = 8
        clipsToBounds = true
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(
            checkBaseView.with(
                checkIconView,
                checkContentLabel
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        checkBaseView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(46)
            $0.width.equalTo(82)
        }
        
        checkIconView.snp.makeConstraints {
            $0.size.equalTo(24)
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        checkContentLabel.snp.makeConstraints {
            $0.top.equalTo(checkIconView.snp.bottom)
            $0.centerX.equalToSuperview()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        gradientLayer.frame = bounds
    }
}
