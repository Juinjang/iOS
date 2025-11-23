//
//  PopularImjangNoteAlertView .swift
//  juinjang
//
//  Created by KimDongWoo on 4/12/25.
//

import UIKit
import Then
import SnapKit

final class PopularImjangNoteBannerView: BaseView {
    private let iconView = UIImageView().then {
        $0.image = .award
    }
    
    private let boldLabel = DSLabel(.h1).then {
        $0.fontSize = 14
        $0.fontColor = .main
        $0.text = "인기 임장노트"
    }
    
    private let contentLabel = DSLabel(.body).then {
        $0.fontSize = 14
        $0.fontColor = .main
    }
    
    func configure(for buyerCount: Int) {
        contentLabel.text = "\(buyerCount)명 이상이 이 노트를 구매했어요"
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .bg2
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(iconView, boldLabel, contentLabel)
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        iconView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalToSuperview().offset(25)
            $0.size.equalTo(24)
        }
        
        boldLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(iconView.snp.right).offset(4)
        }
        
        contentLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.left.equalTo(boldLabel.snp.right).offset(8)
        }
    }
}

