//
//  MyNoteMetaInfoView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/21/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class MyNoteMetaInfoView: BaseView {
    private let profileImageView = UIImageView()
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fill
    }
    
    private let nicknameLabel = BodyLabel().then {
        $0.fontWeight = .regular
        $0.fontColor = .gray400
        $0.fontSize = 13
        $0.lineHeight = 18.85
        $0.letterSpacing = -0.2
        $0.maxTextWidth = 24
    }
    
    private let createDateLabel = BodyLabel().then {
        $0.fontWeight = .regular
        $0.fontColor = .gray400
        $0.fontSize = 13
        $0.lineHeight = 18.85
        $0.letterSpacing = -0.2
    }
    
    private let viewCountBaseView = UIView()
    
    private let viewCountIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .eye
    }
    
    private let viewCountLabel = BodyLabel().then {
        $0.fontWeight = .regular
        $0.fontAlignment = .center
        $0.fontColor = .gray400
        $0.fontSize = 13
        $0.lineHeight = 18.85
        $0.letterSpacing = -0.2
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add([
            profileImageView,
            stackView
        ])
        
        [nicknameLabel,
         makeDotLabel(),
         createDateLabel,
         makeDotLabel(),
         viewCountBaseView.with(
            viewCountIconView,
            viewCountLabel
         )].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        profileImageView.snp.makeConstraints {
            $0.size.equalTo(18)
            $0.centerY.left.equalToSuperview()
        }
        
        viewCountBaseView.snp.makeConstraints {
            $0.height.equalTo(19)
        }
        
        viewCountIconView.snp.makeConstraints {
            $0.size.equalTo(16)
            $0.left.centerY.equalToSuperview()
        }
        
        viewCountLabel.snp.makeConstraints {
            $0.left.equalTo(viewCountIconView.snp.right).offset(2)
            $0.centerY.equalToSuperview()
        }
        
        stackView.snp.makeConstraints {
            $0.height.equalTo(19)
            $0.left.equalTo(profileImageView.snp.right).offset(4)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(_ model: MyNoteMetaInfoModel) {
        profileImageView.kf.setImage(
            with: URL(string: model.imageUrl),
            placeholder: UIImage.Setting.profile
        )
        nicknameLabel.text = model.nickname
        createDateLabel.text = model.createDate
        viewCountLabel.text = model.viewCount
    }
    
    func reset() {
        profileImageView.kf.cancelDownloadTask()
        profileImageView.image = UIImage.Setting.profile
        nicknameLabel.text = nil
        createDateLabel.text = nil
        viewCountLabel.text = nil
    }
    
    private func makeDotLabel() -> UILabel {
        return BodyLabel().then {
            $0.fontSize = 13
            $0.lineHeight = 18.85
            $0.letterSpacing = -0.2
            $0.fontColor = .gray300
            $0.fontAlignment = .center
            $0.text = "・"
        }.then { label in
            label.snp.makeConstraints {
                $0.width.equalTo(13)
            }
        }
    }
}
