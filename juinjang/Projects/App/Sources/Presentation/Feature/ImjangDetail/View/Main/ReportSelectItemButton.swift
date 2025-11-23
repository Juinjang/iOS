//
//  ReportSelectItemButton.swift
//  juinjang
//
//  Created by KimDongWoo on 6/1/25.
//

import UIKit
import Then
import SnapKit

final class ReportSelectItemButton: UIButton {
    private let reportSelectIcon = UIImageView()
    
    override var isSelected: Bool {
        didSet {
            reportSelectIcon.image = isSelected
            ? .reportSelectedIcon
            : .reportDeselectedIcon
        }
    }
    
    private let contentLabel = DSLabel(.body2).then {
        $0.fontColor = .gray600
    }
    
    init(title: String) {
        super.init(frame: .zero)
        isSelected = false
        contentLabel.text = title
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        add(reportSelectIcon, contentLabel)
    }
    
    private func configureLayout() {
        reportSelectIcon.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(reportSelectIcon.snp.right).offset(4)
        }
    }
}
