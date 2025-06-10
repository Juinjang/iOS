//
//  PurchasePopupViewController.swift
//  juinjang
//
//  Created by 조유진 on 5/4/25.
//

import UIKit
import Then
import SnapKit

final class PurchasePopupViewController: BaseAlertViewController {
    private let titleLabel = UILabel()
    private let myPencilCountView: MyPencilCountView
    
    init(purchasedPencilCount: Int, currentPencilCount: Int) {
        self.myPencilCountView = MyPencilCountView(pencilCount: currentPencilCount)
        super.init(
            height: 257,
            isShowDismissButton: true,
            contentViews: [
                titleLabel,
                myPencilCountView
            ],
            buttons: [
                .confirm(title: "확인")
            ]
        )
        setTitle(purchasedPencilCount: purchasedPencilCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentLayout() {
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().offset(48)
            $0.centerX.equalToSuperview()
        }
        
        myPencilCountView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(63)
        }
    }
    
    private func setTitle(purchasedPencilCount: Int) {
        let fullText = "연필 \(purchasedPencilCount)개 구매 완료!"
        titleLabel.text = fullText
        titleLabel.textColor = .gray600
        titleLabel.font =  .pretendard(size: 20, weight: .bold)
        titleLabel.asColor(targetString: "\(purchasedPencilCount)", color: .main)
        titleLabel.textAlignment = .center
    }
}

fileprivate final class MyPencilCountView: BaseView {
    private let myPencilLabel = UILabel().then {
        $0.setAttribute(
            text: "나의 연필",
            color: .gray450,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            charSpacing: -0.02
        )
    }
    
    private let pencilImageView = UIImageView().then {
        $0.image = .ImjangList.pencil
        $0.contentMode = .scaleAspectFit
    }
    
    private let pencilCountLabel = UILabel()
    
    init(pencilCount: Int) {
        super.init(frame: .zero)
        backgroundColor = .gray100
        layer.cornerRadius = 10
        
        pencilCountLabel.setAttribute(
            text: "\(pencilCount)",
            color: .main,
            font: .pretendard(size: 16, weight: .semiBold),
            lineHeight: 23,
            charSpacing: -0.02
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(myPencilLabel, pencilCountLabel, pencilImageView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        myPencilLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        pencilCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
        
        pencilImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalTo(pencilCountLabel.snp.leading).offset(-4)
            make.centerY.equalTo(pencilCountLabel)
        }
    }
    
    func configureView(pencilCount: Int) {
        print(#function)
    }
}

