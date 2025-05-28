//
//  PhotoRegisterButton.swift
//  juinjang
//
//  Created by KimDongWoo on 5/27/25.
//

import UIKit
import Then
import SnapKit

final class PhotoRegisterButton: UIButton {
    private let plusIconView = UIImageView().then {
        $0.image = .addOrange
    }
    
    private let mainTitleLabel = DSLabel(.reguler).then {
        $0.fontSize = 14
        $0.fontColor = .mainWhite
        $0.text = "사진 등록"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
        configureHierarchy()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .gray450
        roundCorners(cornerRadius: 13.5, corner: .all)
    }
    
    private func configureHierarchy() {
        add(plusIconView, mainTitleLabel)
    }
    
    private func configureLayout() {
        plusIconView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(10)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(16)
        }
        
        mainTitleLabel.snp.makeConstraints {
            $0.left.equalTo(plusIconView.snp.right).offset(6)
            $0.centerY.equalToSuperview()
        }
    }
}
