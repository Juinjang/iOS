//
//  ReportGraphView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/14/25.
//


import UIKit
import Then
import SnapKit

final class ReportGraphView: BaseView {
    private let graphView = TriangleGraphView()
    private let indoorLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .gray450
        $0.text = "실내"
    }
    
    private let publicSpaceLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .gray450
        $0.text = "공용\n공간"
        $0.numberOfLines = 2
    }
    
    private let locationConditionsLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .gray450
        $0.text = "입지\n여건"
    }
    
    func configure(for model: ImjangDetailReportModel) {
        graphView.configure(for: [
            TriangleGraphModel(
                rates: [model.indoorRate,
                        model.locationConditionsRate,
                        model.publicSpaceRate],
                isGradient: true,
                gradientColors: [
                    UIColor.mainGradientTriangle1.cgColor,
                    UIColor.mainGradientTriangle2.cgColor
                ]
            )
        ])
    }
    
    override func configureView() {
        super.configureView()
        roundCorners(cornerRadius: 5, corner: .all)
        layer.borderColor = UIColor.stroke.cgColor
        layer.borderWidth = 1
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 2)
        layer.shadowRadius = 3
        layer.shadowOpacity = 0.1
        layer.masksToBounds = false
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(graphView,
            indoorLabel,
            publicSpaceLabel,
            locationConditionsLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        graphView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(-5)
            $0.centerX.equalToSuperview()
            $0.size.equalTo(237)
        }
        
        indoorLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(20)
            $0.centerX.equalToSuperview()
        }
        
        publicSpaceLabel.snp.makeConstraints {
            $0.left.equalToSuperview().offset(32)
            $0.bottom.equalToSuperview().inset(24)
        }
        
        locationConditionsLabel.snp.makeConstraints {
            $0.right.equalToSuperview().inset(32)
            $0.bottom.equalToSuperview().inset(24)
        }
    }
}
