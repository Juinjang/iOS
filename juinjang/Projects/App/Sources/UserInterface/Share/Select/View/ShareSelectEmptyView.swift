//
//  ImjangShareSelectEmptyCell.swift
//  juinjang
//
//  Created by KimDongWoo on 4/27/25.
//

import UIKit
import Then
import SnapKit

final class ShareSelectEmptyView: BaseView {
    private let containerView = UIView()
    
    private let emptyImageView = UIImageView().then {
        $0.image = .emptyCell
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontColor = .gray400
        $0.text = "임장노트 공유조건을 충족한 임장노트가 없어요\n조건을 채우러 가볼까요?"
        $0.numberOfLines = 2
        $0.fontAlignment = .center
    }
    
    private let noteButton = FilledButton(title: "나의 임장노트 가기")
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            containerView.with(
                emptyImageView,
                contentLabel,
                noteButton
            )
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        containerView.snp.makeConstraints {
            $0.height.equalTo(284)
            $0.width.equalTo(301)
            $0.center.equalToSuperview()
        }
        
        emptyImageView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
            $0.height.equalTo(154)
            $0.width.equalTo(216)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(emptyImageView.snp.bottom).offset(8)
            $0.height.equalTo(48)
            $0.width.equalTo(301)
            $0.centerX.equalToSuperview()
        }
        
        noteButton.snp.makeConstraints {
            $0.top.equalTo(contentLabel.snp.bottom).offset(24)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
            $0.width.equalTo(202)
        }
    }
}
