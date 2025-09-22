//
//  CheckAnswerView.swift
//  juinjang
//
//  Created by KimDongWoo on 4/18/25.
//

import UIKit
import Then
import SnapKit

final class CheckAnswerView: BaseView {
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 20
        $0.distribution = .equalSpacing
    }
    
    func configure(for selectedIndex: String) {
        guard let selectedIndex = Int(selectedIndex) else { return }
        stackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        // 1~5 이미지뷰 생성 및 추가
        (1...5).map { index in
            UIImageView().then {
                $0.image = index == selectedIndex
                ? UIImage.CheckList.checkedButton
                : UIImage.CheckList.savedButton
                $0.contentMode = .scaleAspectFit
                $0.snp.makeConstraints {
                    $0.size.equalTo(31)
                }
            }
        }.forEach { stackView.addArrangedSubview($0) }
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(stackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        stackView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
