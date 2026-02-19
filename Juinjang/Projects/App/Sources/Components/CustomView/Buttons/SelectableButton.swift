//
//  SelectableButton.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

import UIKit
import Then
import SnapKit

final class SelectableButton: UIButton {
    private let contentLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .black
        $0.fontAlignment = .left
    }
    
    override var isSelected: Bool {
        didSet {
            isSelected ? setupForSelected() : setupForDeselected()
        }
    }
    
    init(title: String) {
        super.init(frame: .zero)
        self.contentLabel.text = title
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        roundCorners(cornerRadius: 10, corner: .all)
        layer.borderWidth = 1.5
    }
    
    private func configureHierarchy() {
        add(contentLabel)
    }
    
    private func configureLayout() {
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(16)
        }
    }
}

extension SelectableButton {
    private func setupForSelected() {
        layer.borderColor = UIColor.mainStroke.cgColor
        backgroundColor = .bg2
    }
    
    private func setupForDeselected() {
        layer.borderColor = UIColor.stroke.cgColor
        backgroundColor = .mainWhite
    }
}
