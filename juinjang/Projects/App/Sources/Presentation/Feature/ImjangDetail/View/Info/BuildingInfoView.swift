//
//  BuildingInfoView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/13/25.
//

import UIKit
import Then
import SnapKit

final class BuildingInfoView: BaseView {
    private let infoStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 22
    }
    
    private let infoContentStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 22
    }
    
    private let infoStackViewSubViews: [DSLabel] = (0..<3).map { _ in
        DSLabel(.body).then {
            $0.fontColor = .gray400
            $0.textAlignment = .left
        }
    }
    
    private let infoContentStackViewSubViews: [DSLabel] = (0..<3).map { _ in
        DSLabel(.body).then {
            $0.fontColor = .gray600
            $0.textAlignment = .left
        }
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    func configure(for model: ImjangDetailInfoModel) {
        guard let propertyType = PropertyType(rawValue: model.propertyType)?.title else { return }
        
        zip(["\(propertyType)명",
             "층수",
             "평수"],
            infoStackViewSubViews).forEach { text, label in
            label.text = text
        }
        
        zip(["\(model.buildingName)",
             "\(model.floor)층",
             "\(model.pyong)평"],
            infoContentStackViewSubViews).forEach { text, label in
            label.text = text
        }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(infoStackView,
            infoContentStackView,
            separatorView)
        
        infoStackViewSubViews.forEach {
            infoStackView.addArrangedSubview($0)
        }
        
        infoContentStackViewSubViews.forEach {
            infoContentStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        infoStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalToSuperview().offset(24)
            $0.height.equalTo(113)
            $0.width.equalTo(85)
        }
        
        infoContentStackView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.left.equalTo(infoStackView.snp.right).offset(33)
            $0.right.equalToSuperview().inset(39)
            $0.height.equalTo(113)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.left.equalToSuperview().offset(24)
            $0.right.equalToSuperview().inset(39)
            $0.bottom.equalToSuperview()
        }
    }
}
