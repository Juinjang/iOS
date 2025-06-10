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
        profileImageView.kf.setImage(with: URL(string: model.owerProfileUrl))
        nicknameLabel.text = model.owerNickname
        introductionLabel.text = model.ownerProfileBio
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
