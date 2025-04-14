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
    
    private let reportInfoView = ReportInfoView().then {
        $0.roundCorners(cornerRadius: 5, corner: .all)
        $0.layer.borderColor = UIColor.stroke.cgColor
        $0.layer.borderWidth = 1
        $0.layer.shadowColor = UIColor.black.cgColor
        $0.layer.shadowOffset = CGSize(width: 0, height: 2)
        $0.layer.shadowRadius = 6
        $0.layer.shadowOpacity = 0.1
        $0.layer.masksToBounds = false
    }
    
    func bind(_ reportModel: ImjangDetailReportModel) {
        reportInfoView.configure(for: reportModel)
    }
    
    override func configureView() {
        super.configureView()
        self.contentView.backgroundColor = .gray100
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(titleLabel, reportInfoView)
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
    }
}
