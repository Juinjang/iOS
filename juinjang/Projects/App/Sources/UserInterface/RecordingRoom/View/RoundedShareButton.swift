//
//  RoundedShareButton.swift
//  juinjang
//
//  Created by KimDongWoo on 5/27/25.
//

import UIKit
import Then
import SnapKit

final class RoundedShareButton: UIButton {
    private let contentLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .main
        $0.text = "공유하기"
    }
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureView() {
        backgroundColor = .main100
        roundCorners(cornerRadius: 8, corner: .all)
        
        addSubview(contentLabel)
        
        contentLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
