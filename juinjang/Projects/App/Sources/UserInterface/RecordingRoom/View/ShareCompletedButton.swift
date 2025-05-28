//
//  ShareCompletedButton.swift
//  juinjang
//
//  Created by KimDongWoo on 5/28/25.
//

import UIKit
import Then
import SnapKit

final class ShareCompletedButton: UIButton {
    private let mainTitleLabel = DSLabel(.title).then {
        $0.fontSize = 14
        $0.fontColor = .main
        $0.text = "공유가 완료된 임장노트예요\n공유 후에는 수정할 수 없어요"
        $0.fontAlignment = .center
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
        backgroundColor = .gray100
        roundCorners(cornerRadius: 8, corner: .all)
    }
    
    private func configureHierarchy() {
        add(mainTitleLabel)
    }
    
    private func configureLayout() {
        mainTitleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
    }
}
