//
//  EmptyPencilView.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit
import Then
import SnapKit

final class EmptyPencilView: UIStackView {
    private let imageView = UIImageView().then {
        $0.image = .emptyPencil
        $0.contentMode = .scaleAspectFit
    }
    
    private let descriptionLabel = UILabel().then {
        $0.numberOfLines = 0
    }
    
    init(description: String) {
        super.init(frame: .zero)
        configureHierarchy()
        configureLayout()
        configureView(description: description)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        [imageView, descriptionLabel].forEach {
            self.addSubview($0)
        }
    }
    
    func configureLayout() {
        imageView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.width.equalTo(234)
            make.height.equalTo(154)
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(8)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }
    }
    
    func configureView(description: String) {
        axis = .vertical
        alignment = .center
        distribution = .fill
        spacing = 8
        
        descriptionLabel.setAttribute(
            text: description,
            color: .gray400,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            charSpacing: -0.02,
            alignment: .center
        )
    }
}
