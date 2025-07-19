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
    private let profileImageView = UIImageView().then {
        $0.roundCorners(cornerRadius: 9, corner: .all)
        $0.clipsToBounds = true
    }
    
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 0
        $0.distribution = .fill
    }
    
    private let nicknameLabel = DSLabel(.reguler).then {
        $0.fontColor = .gray400
        $0.maxTextWidth = 24
    }
    
    private let createDateLabel = DSLabel(.reguler).then {
        $0.fontWeight = .regular
        $0.fontColor = .gray400
    }
    
    private let viewCountBaseView = UIView()
    
    private let viewCountIconView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = .eye
    }
    
    private let viewCountLabel = DSLabel(.reguler).then {
        $0.fontAlignment = .center
        $0.fontColor = .gray400
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
        return DSLabel(.reguler).then {
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
