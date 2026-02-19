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
        $0.spacing = 4
    }
    private let infoCircleImageView = UIImageView().then {
        let image = UIImage.infoCircle
        $0.image = image.withTintColor(.gray300)
        $0.contentMode = .scaleAspectFit
    }
    
    private let guideLabel = DSLabel(.body2).then {
        $0.fontColor = .gray400
        $0.textAlignment = .center
    }
    
    func configureHeader(guideMessage: String) {
        guideLabel.text = guideMessage
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
