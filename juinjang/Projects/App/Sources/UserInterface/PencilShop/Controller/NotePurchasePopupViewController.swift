//
//  NotePurchasePopupViewController.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

import UIKit
import Then
import SnapKit

final class NotePurchasePopupViewController: BaseAlertViewController {
    private let buildingNameLabel = UILabel()
    private let scoreLabel = UILabel()
    private let myPencilCountView: NotePurchaseStatusView
    
    init(buildingName: String, score: Double, currentPencilCount: Int, neededPencilCount: Int) {
        self.myPencilCountView = NotePurchaseStatusView(pencilCount: currentPencilCount, neededPencilCount: neededPencilCount)
        super.init(
            height: 257,
            isShowDismissButton: true,
            contentViews: [
                buildingNameLabel,
                scoreLabel,
                myPencilCountView
            ],
            buttons: [
                .confirm(title: "매물 바로 보러 가기")
            ]
        )
        setBuildingName(buildingName: buildingName)
        setScore(score: score)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureContentLayout() {
        buildingNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(29)
            make.centerX.equalToSuperview()
        }
        
        scoreLabel.snp.makeConstraints { make in
            make.top.equalTo(buildingNameLabel.snp.bottom).offset(4)
            make.centerX.equalToSuperview()
        }
        
        myPencilCountView.snp.makeConstraints { make in
            make.centerY.equalToSuperview().offset(6)
            make.centerX.equalToSuperview()
            make.width.equalTo(200)
            make.height.equalTo(78)
        }
    }
    
    private func setBuildingName(buildingName: String) {
        buildingNameLabel.text = buildingName
        buildingNameLabel.textColor = .gray600
        buildingNameLabel.font =  .pretendard(size: 20, weight: .bold)
        buildingNameLabel.textAlignment = .center
    }
    
    private func setScore(score: Double) {
        let attributedString1 = NSMutableAttributedString(string: "\(score)", attributes: [.font: UIFont.pretendard(size: 20, weight: .semiBold)])
        
        let imageAttachment1 = NSTextAttachment()
        imageAttachment1.image = UIImage.ImjangList.starRounded.withTintColor(.main)
        imageAttachment1.bounds = CGRect(x: 0, y: -3, width: 20, height: 20)
        
        attributedString1.insert(NSAttributedString(attachment: imageAttachment1), at: 0)
        
        scoreLabel.attributedText = attributedString1
        scoreLabel.textColor = .gray400
        scoreLabel.textAlignment = .center
    }
}

fileprivate final class NotePurchaseStatusView: BaseView {
    private let myPencilLabel = DSLabel(.body).then {
        $0.fontColor = .gray450
    }
    
    private let neededPencilLabel = DSLabel(.body).then {
        $0.fontColor = .gray450
    }
    
    private lazy var pencilImageView = makePencilImageView()
    
    private lazy var pencilImageView2 = makePencilImageView()
    
    private let myPencilCountLabel = UILabel()
    private let neededPencilCountLabel = UILabel()
    
    init(pencilCount: Int, neededPencilCount: Int) {
        super.init(frame: .zero)
        configureView(pencilCount: pencilCount, neededPencilCount: neededPencilCount)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            myPencilLabel,
            myPencilCountLabel,
            pencilImageView,
            neededPencilLabel,
            neededPencilCountLabel,
            pencilImageView2
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        myPencilLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(12)
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        myPencilCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(myPencilLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        pencilImageView.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalTo(myPencilCountLabel.snp.leading).offset(-4)
            make.centerY.equalTo(myPencilLabel)
        }
        
        neededPencilLabel.snp.makeConstraints { make in
            make.top.equalTo(myPencilLabel.snp.bottom).offset(8)
            make.leading.equalToSuperview().offset(16)
            make.bottom.equalToSuperview().offset(-12)
        }
        
        neededPencilCountLabel.snp.makeConstraints { make in
            make.centerY.equalTo(neededPencilLabel)
            make.trailing.equalToSuperview().inset(16)
        }
        
        pencilImageView2.snp.makeConstraints { make in
            make.size.equalTo(20)
            make.trailing.equalTo(neededPencilCountLabel.snp.leading).offset(-4)
            make.centerY.equalTo(neededPencilLabel)
        }
    }
    
    func configureView(pencilCount: Int, neededPencilCount: Int) {
        backgroundColor = .gray100
        layer.cornerRadius = 10
        
        myPencilCountLabel.setAttribute(
            text: "\(pencilCount)",
            color: .main,
            font: .pretendard(size: 16, weight: .semiBold),
            lineHeight: 23,
            charSpacing: -0.02
        )
        
        neededPencilCountLabel.setAttribute(
            text: "\(neededPencilCount)",
            color: .main,
            font: .pretendard(size: 16, weight: .semiBold),
            lineHeight: 23,
            charSpacing: -0.02
        )
    }
    
    private func makePencilImageView() -> UIImageView {
        let imageView = UIImageView()
        imageView.image = .ImjangList.pencil
        imageView.contentMode = .scaleAspectFit
        return imageView
    }
}

