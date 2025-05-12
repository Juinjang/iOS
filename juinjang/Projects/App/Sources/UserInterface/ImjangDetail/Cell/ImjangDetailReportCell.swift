//
//  ImjangReportCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/10/25.
//

import UIKit
import Then
import SnapKit

final class ImjangDetailReportCell: BaseCollectionViewCell {
    private let titleLabel = DSLabel(.h3).then {
        $0.text = "리포트"
        $0.textColor = .gray600
    }
    
    private let reportInfoView = ReportInfoView()
    private let reportGraphView = ReportGraphView()
    
    func bind(_ reportModel: ImjangDetailReportModel) {
        reportInfoView.configure(for: reportModel)
        reportGraphView.configure(for: reportModel)
    }
    
    override func configureView() {
        super.configureView()
        self.contentView.backgroundColor = .gray100
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(
            titleLabel,
            reportInfoView,
            reportGraphView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(37)
            $0.left.equalToSuperview().offset(24)
        }
        
        reportInfoView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(9)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(198)
        }
        
        reportGraphView.snp.makeConstraints {
            $0.top.equalTo(reportInfoView.snp.bottom).offset(12)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(278)
        }
    }
}
