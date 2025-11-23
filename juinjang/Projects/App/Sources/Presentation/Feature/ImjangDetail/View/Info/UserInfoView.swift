//
//  UserInfoView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/13/25.
//

import UIKit
import Then
import SnapKit
import Kingfisher

final class UserInfoView: BaseView {
    private let profileImageView = UIImageView().then {
        $0.roundCorners(cornerRadius: 24, corner: .all)
        $0.backgroundColor = .gray350
    }
    
    private let nicknameLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
    }
    
    private let introductionLabel = DSLabel(.body2).then {
        $0.fontColor = .gray400
    }
    
    private let separatorView = UIView().then {
        $0.backgroundColor = .stroke
    }
    
    func configure(for model: ImjangDetailInfoModel) {
        if let profileUrl = model.ownerProfileUrl {
            profileImageView.kf.setImage(with: URL(string: model.ownerProfileUrl ?? ""))
        } else {
            profileImageView.image = .Setting.profile
        }
        nicknameLabel.text = model.ownerNickname
        introductionLabel.text = model.ownerProfileBio ?? "안녕하세요. \(model.ownerNickname) 입니다."
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(profileImageView,
            nicknameLabel,
            introductionLabel,
            separatorView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        profileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
            $0.size.equalTo(48)
        }
        
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(profileImageView.snp.top).offset(1.5)
            $0.left.equalTo(profileImageView.snp.right).offset(12)
        }
        
        introductionLabel.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(2)
            $0.left.equalTo(nicknameLabel.snp.left)
        }
        
        separatorView.snp.makeConstraints {
            $0.height.equalTo(1)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview()
        }
    }
}
