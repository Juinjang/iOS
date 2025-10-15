//
//  MoreButton.swift
//  juinjang
//
//  Created by 조유진 on 6/30/25.
//

import UIKit

final class MoreButton: UIButton {
    private let contentBaseView = UIView()
    
    private let contentLabel = DSLabel(.body2).then {
        $0.fontColor = .gray450
        $0.text = "더보기"
    }
    
    private let downIconView = UIImageView().then {
        $0.image = .ImjangList.arrowDown
    }
    
    init() {
        super.init(frame: .zero)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        roundCorners(cornerRadius: 10, corner: .all)
        backgroundColor = .gray100
    }
    
    private func configureHierarchy() {
        add(contentBaseView.with(
            contentLabel,
            downIconView
        ))
    }
    
    private func configureLayout() {
        contentBaseView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(52)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        downIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview()
            $0.size.equalTo(14)
        }
    }
}
