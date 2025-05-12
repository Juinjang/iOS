//
//  PencilAlertView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/19/25.
//

import UIKit
import Then
import SnapKit

final class PencilAlertView: BaseAlertViewController {
    private let titleLabel = DSLabel(.h2).then {
        $0.fontColor = .gray600
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontColor = .gray500
    }
    
    private let myPencilView = MyPencilView()
    
    private let customButtonView = NoteOpenView()
    
    init(title: String,
         pencilCount: Int,
         needPencilCount: Int) {
        let isNeedPencil = pencilCount < needPencilCount
        
        super.init(
            height: 257,
            isShowDismissButton: true,
            contentViews: [
                titleLabel,
                contentLabel,
                myPencilView
            ],
            buttons: [
                isNeedPencil
                ? .confirm(title: "연필 상점으로 가기")
                : .custom(view: customButtonView)
            ]
        )
        
        titleLabel.text = title
        contentLabel.text = isNeedPencil 
        ? "연필이 부족해요:("
        : "노트를 구매할까요?"
        
        myPencilView.configure(count: pencilCount,
                               needCount: needPencilCount)
        customButtonView.configure(for: pencilCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentHierarchy() {
        super.configureContentHierarchy()
    }
    
    override func configureContentLayout() {
        super.configureContentLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(18)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(52)
        }
        
        contentLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(65)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(23)
        }
        
        myPencilView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(96)
            $0.horizontalEdges.equalToSuperview().inset(71)
            $0.height.equalTo(78)
            $0.centerX.equalToSuperview()
        }
    }
}

fileprivate final class NoteOpenView: BaseView {
    private let contentLabel = DSLabel(.title).then {
        $0.fontColor = .mainWhite
        $0.text = "노트 열기"
    }
    
    private let pencilIconView = UIImageView().then {
        $0.image = .pencil20
    }
    
    private let countLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .main
    }
    
    func configure(for pencilCount: Int) {
        countLabel.text = "\(pencilCount)"
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .clear
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        add(contentLabel,
            pencilIconView,
            countLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().inset(10)
        }
        
        pencilIconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(contentLabel.snp.right).offset(4)
            $0.size.equalTo(20)
        }
        
        countLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(pencilIconView.snp.right).offset(4)
            $0.right.equalToSuperview().inset(10)
        }
    }
}


fileprivate final class MyPencilView: BaseView {
    private let itemView = PencilItemView()
    private let needItemView = PencilItemView()
    
    func configure(count: Int,
                   needCount: Int) {
        itemView.configure(text: "나의 연필", count: count)
        needItemView.configure(text: "필요한 연필", count: needCount)
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .gray100
        roundCorners(cornerRadius: 10, corner: .all)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(itemView, needItemView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        itemView.snp.makeConstraints {
            $0.top.equalToSuperview().offset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
            $0.height.equalTo(23)
        }
        
        needItemView.snp.makeConstraints {
            $0.height.equalTo(23)
            $0.bottom.equalToSuperview().inset(12)
            $0.horizontalEdges.equalToSuperview().inset(16)
        }
    }
}

fileprivate final class PencilItemView: UIView {
    private let textLabel = DSLabel(.body).then {
        $0.fontColor = .gray450
    }
    
    private let iconView = UIImageView().then {
        $0.image = .pencil20
    }
    
    private let countLabel = DSLabel(.title).then {
        $0.fontColor = .main
    }
    
    init() {
        super.init(frame: .zero)
        configureUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(text: String,
                   count: Int) {
        textLabel.text = text
        countLabel.text = "\(count)"
    }

    private func configureUI() {
        add(textLabel, iconView, countLabel)
        
        textLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview()
        }
        
        iconView.snp.makeConstraints {
            $0.size.equalTo(20)
            $0.centerY.equalToSuperview()
            $0.right.equalTo(countLabel.snp.left).offset(-4)
        }
        
        countLabel.snp.makeConstraints {
            $0.right.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
    }
}
