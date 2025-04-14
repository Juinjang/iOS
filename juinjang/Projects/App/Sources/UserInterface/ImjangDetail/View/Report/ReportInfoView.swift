//
//  ReportInfoView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/14/25.
//

import UIKit
import Then
import SnapKit

final class ReportInfoView: BaseView {
    private let contentLabel = DSLabel(.body).then {
        $0.fontColor = .gray430
    }
    
    private let verticalStackView = UIStackView().then {
        $0.axis = .vertical
        $0.spacing = 8
    }
    
    private let infoContentStackViewSubViews: [ReportInfoKeywordView] = (0..<3).map { _ in
        ReportInfoKeywordView().then {
            $0.snp.makeConstraints { make in
                make.height.equalTo(23.2)
            }
        }
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    private let totalInfoKeywordView = ReportInfoKeywordView()
    
    func configure(for model: ImjangDetailReportModel) {
        contentLabel.text = "이곳은 한 마디로..."
        
        zip(
            infoContentStackViewSubViews,
            [(model.indoorKeyword, "실내", model.indoorRate),
             (model.publicSpaceKeyword, "공용 공간", model.publicSpaceRate),
             (model.locationConditionsKeyword, "입지 여건", model.locationConditionsRate)]
        ).forEach { view, data in
            view.configure(
                keywordText: data.0,
                contentText: data.1,
                rate: data.2
            )
        }
        
        totalInfoKeywordView.configure(
            keywordText: "총점",
            contentText: "",
            rate: model.totalRate,
            isTotalLabel: true
        )
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(contentLabel,
            verticalStackView,
            separatorView,
            totalInfoKeywordView)
        
        infoContentStackViewSubViews.forEach { verticalStackView.addArrangedSubview($0) }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        contentLabel.snp.makeConstraints {
            $0.height.equalTo(23)
            $0.horizontalEdges.equalToSuperview().inset(11.5)
            $0.top.equalToSuperview().offset(16)
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(14)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(88)
        }
        
        separatorView.snp.makeConstraints {
            $0.top.equalTo(verticalStackView.snp.bottom).offset(8)
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview().inset(11.5)
        }
        
        totalInfoKeywordView.snp.makeConstraints {
            $0.top.equalTo(separatorView.snp.bottom).offset(8)
            $0.height.equalTo(24)
            $0.horizontalEdges.equalToSuperview()
        }
    }
}

