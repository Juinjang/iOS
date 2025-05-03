//
//  PencilGuideHeader.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit
import SnapKit

final class PencilGuideHeader: BaseCollectionReusableView {
    private let stackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .center
        $0.spacing = 1
    }
    private let infoCircleImageView = UIImageView().then {
        $0.image = .infoCircle
        $0.contentMode = .scaleAspectFit
    }
    private let guideLabel = UILabel().then {
        $0.textAlignment = .center
    }
    
    func configureHeader(guideMessage: String) {
        guideLabel.setAttribute(
            text: guideMessage,
            color: .gray300,
            font: .pretendard(size: 14, weight: .medium),
            lineHeight: 20,
            charSpacing: -0.02,
            alignment: .center
        )
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        [infoCircleImageView, guideLabel].forEach {
            stackView.addArrangedSubview($0)
        }
        add(stackView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        infoCircleImageView.snp.makeConstraints { make in
            make.size.equalTo(19)
        }
        stackView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
    
    override func configureView() {
        super.configureView()
        backgroundColor = .gray100
    }
}
