//
//  ShareWriteNoticeCell.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

import UIKit
import Then
import SnapKit

final class ShareWriteNoticeCell: BaseCollectionViewCell {
    private let baseView = UIView().then {
        $0.backgroundColor = .gray100
        $0.roundCorners(cornerRadius: 4, corner: .all)
    }
    
    private let pencilIconBaseView = UIView().then {
        $0.backgroundColor = .main150
        $0.roundCorners(cornerRadius: 14, corner: .all)
    }
    
    private let pencilIconView = UIImageView().then {
        $0.image = .pencil20
    }
    
    private let contentLabel = DSLabel(.title).then {
        $0.fontColor = .gray500
        $0.fontSize = 14
        $0.fontAlignment = .left
        $0.text = "임장노트를 공유하면 받을 수 있는 연필"
    }
    
    private let pencilCountLabel = DSLabel(.title).then {
        $0.fontColor = .main
        $0.fontSize = 14
        $0.fontAlignment = .center
    }
    
    func bind(item: ShareSelectModel) {
        pencilCountLabel.text = "\(item.rewardPencil)개"
    }
    
    override func configureView() {
        super.configureView()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(
            baseView.with(
                pencilIconBaseView.with(
                    pencilIconView
                ),
                contentLabel,
                pencilCountLabel
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(48)
        }
        
        pencilIconBaseView.snp.makeConstraints {
            $0.size.equalTo(28)
            $0.left.equalToSuperview().offset(16)
            $0.centerY.equalToSuperview()
        }
        
        pencilIconView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.center.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.left.equalTo(pencilIconBaseView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        pencilCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.equalTo(29)
            $0.right.equalToSuperview().inset(16)
        }
    }
}
