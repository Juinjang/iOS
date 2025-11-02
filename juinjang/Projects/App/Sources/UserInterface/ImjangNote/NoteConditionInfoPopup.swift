//
//  NoteConditionInfoPopup.swift
//  App
//
//  Created by 조유진 on 11/2/25.
//

import UIKit
import SnapKit
import Then

final class NoteConditionInfoPopup: BaseAlertViewController {
    private let baseView = UIView()
    
    private let titleIconView = UIImageView().then {
        $0.image = .exclamation
    }
    
    private let titleLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
        $0.text = "공유 조건 미충족"
    }
    
    private let baseContentView = UIView().then {
        $0.backgroundColor = .main100
        $0.roundCorners(cornerRadius: 4, corner: .all)
    }
    
    private let contentLabel = DSLabel(.body2).then {
        $0.fontSize = 13
        $0.fontColor = .gray450
        $0.fontAlignment = .center
        $0.text = "매물에 대한 정보와 체크리스트를 모두 입력하면\n임장 노트를 공유할 수 있어요!"
    }
    
    init() {
        super.init(
            height: 202,
            contentViews: [baseView],
            buttons: [
                .confirm(title: "확인했어요")
            ]
        )
        view.backgroundColor = .black.withAlphaComponent(0.6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
        
        baseView.add(
            titleIconView,
            titleLabel,
            baseContentView.with(
                contentLabel
            )
        )
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        baseView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.height.equalTo(114)
        }
        
        titleIconView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.right.equalTo(titleLabel.snp.left).offset(-6)
            $0.size.equalTo(20)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(24)
            $0.centerX.equalToSuperview().offset(6)
        }
        
        baseContentView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(13)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(54)
        }
        
        contentLabel.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(8)
        }
    }
}
