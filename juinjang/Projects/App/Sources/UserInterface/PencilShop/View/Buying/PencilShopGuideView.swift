//
//  PencilShopGuideView.swift
//  juinjang
//
//  Created by 조유진 on 4/5/25.
//

import UIKit
import SnapKit

final class PencilShopGuideView: UIView {
    private let stackView = UIStackView().then {
        $0.alignment = .center
        $0.distribution = .fill
        $0.axis = .vertical
    }
    
    private let imageView = UIImageView().then {
        $0.design(image: .pencilNote, contentMode: .scaleAspectFit)
    }
    
    private let messageLabel = UILabel()
    
    init(message: String, spacing: CGFloat) {
        super.init(frame: .zero)
        
        configureHierarchy()
        configureLayout()
        configureView(message: message, spacing: spacing)
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        addSubview(stackView)
        [imageView, messageLabel].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(170)
            make.height.equalTo(112)
        }
    }
    
    private func configureView(message: String, spacing: CGFloat) {
        stackView.spacing = spacing
        
        messageLabel.setAttribute(
            text: message,
            color: .gray600,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            alignment: .center
        )
    }
}
