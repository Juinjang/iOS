//
//  ReportInfoKeywordView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/14/25.
//

import UIKit
import Then
import SnapKit

final class ReportInfoKeywordView: BaseView {
    private let keywordLabel = DSLabel(.body).then {
        $0.fontColor = .main
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontColor = .gray500
    }
    
    private let starIcon = UIImageView().then {
        $0.image = .starGray16
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let rateLabel = DSLabel(.title).then {
        $0.fontColor = .gray450
    }
    
    func configure(keywordText: String,
                   contentText: String,
                   rate: Double,
                   isTotalLabel: Bool = false) {
        if isTotalLabel {
            starIcon.image = .starMain16
            rateLabel.fontColor = .main
        }
        
        keywordLabel.text = keywordText
        contentLabel.text = contentText
        rateLabel.text = "\(rate)"
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(keywordLabel,
            contentLabel,
            starIcon,
            rateLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        keywordLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(11.5)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(keywordLabel.snp.right).offset(4)
        }
        
        starIcon.snp.makeConstraints {
            $0.right.equalToSuperview().inset(37.5)
            $0.centerY.equalToSuperview().offset(-0.5)
            $0.size.equalTo(14)
        }
        
        rateLabel.snp.makeConstraints {
            $0.left.equalTo(starIcon.snp.right).offset(2)
            $0.centerY.equalToSuperview()
        }
    }
}
