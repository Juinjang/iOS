//
//  ImjangShareSelectNoticeCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import UIKit
import Then
import SnapKit

final class ImjangShareSelectNoticeCell: BaseCollectionViewCell {
    private let firstContentLabel = DSLabel(.h4).then {
        $0.fontColor = .gray600
        $0.fontAlignment = .left
        $0.text = "임장노트 한 개를 선택해주세요!"
    }
    
    private let secondContentLabel = DSLabel(.body2).then {
        $0.fontColor = .gray400
        $0.numberOfLines = 2
        $0.fontAlignment = .left
        $0.text = "임장노트는 '임장 둘러보기'를 통해\n다른 임장러에게 공유돼요."
    }
    
    private let pencilBannerView = UIView().then {
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
    
    private let pencilBannerContentLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .gray500
        $0.fontAlignment = .left
        $0.text = "임장노트를 공유하면 연필을 받을 수 있어요"
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        contentView.add(
            firstContentLabel,
            secondContentLabel,
            pencilBannerView.with(
                pencilIconBaseView.with(
                    pencilIconView
                ),
                pencilBannerContentLabel
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        firstContentLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        secondContentLabel.snp.makeConstraints {
            $0.top.equalTo(firstContentLabel.snp.bottom).offset(8)
            $0.left.equalToSuperview().offset(24)
        }
        
        pencilBannerView.snp.makeConstraints {
            $0.top.equalTo(secondContentLabel.snp.bottom).offset(16)
            $0.height.equalTo(48)
            $0.horizontalEdges.equalToSuperview().inset(24)
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
        
        pencilBannerContentLabel.snp.makeConstraints {
            $0.left.equalTo(pencilIconView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
