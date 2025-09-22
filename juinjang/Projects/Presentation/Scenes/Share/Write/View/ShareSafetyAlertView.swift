//
//  ShareSafetyAlertView.swift
//  juinjang
//
//  Created by KimDongWoo on 7/16/25.
//

import UIKit
import Then
import SnapKit

final class ShareSafetyAlertView: BaseAlertViewController {
    private let baseView = UIView()
    
    private let titleView = UIView()
    
    private let iconView = UIImageView().then {
        $0.image = .exclamation
    }
    private let titleLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
        $0.text = "유해한 콘텐츠가 감지되었어요"
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.textInsets = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        $0.fontSize = 13
        $0.fontColor = .gray450
        $0.backgroundColor = .main100
        $0.fontAlignment = .center
        $0.roundCorners(cornerRadius: 4, corner: .all)
        $0.text = "업로드된 이미지에서 유해할 가능성이 있는 콘텐츠가 감지되었습니다. 잘못된 탐지라면 주인장에 알려주세요."
    }
    
    init() {
        super.init(
            height: 202,
            contentViews: [baseView],
            buttons: [.confirm(title: "확인")]
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
        
        baseView.add(
            titleView.with(
                iconView,
                titleLabel
            ),
            contentLabel
        )
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(74)
        }
        
        titleView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.centerX.equalToSuperview()
        }
        
        iconView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.size.equalTo(20)
            $0.centerY.equalTo(titleLabel.snp.centerY)
        }
        
        titleLabel.snp.makeConstraints {
            $0.left.equalTo(iconView.snp.right).offset(6)
            $0.top.equalToSuperview()
            $0.right.equalToSuperview()
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
}
