//
//  BottomButtonView.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit

final class BottomButtonView: UIStackView {
    private let cancelButton = UIButton()
    private let confirmButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureHierarchy() {
        [cancelButton, confirmButton].forEach {
            self.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        cancelButton.snp.makeConstraints { make in
            make.width.equalTo(109)
            make.height.equalTo(52)
        }
        
        confirmButton.snp.makeConstraints { make in
            make.height.equalTo(52)
        }
    }
    
    private func configureView() {
        spacing = 8
        isLayoutMarginsRelativeArrangement = true
        directionalLayoutMargins = NSDirectionalEdgeInsets(top: 12, leading: 24, bottom: 12, trailing: 24)
        backgroundColor = .mainWhite
        
        layer.shadowRadius = 16
        layer.shadowOpacity = 0.08
        layer.shadowOffset = CGSize(width: 0, height: -2)
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false
        
        designButton(button: cancelButton, title: "취소", backgroundColor: .gray3, foregroundColor: .gray500)
        designButton(button: confirmButton, title: "확인", backgroundColor: .main, foregroundColor: .mainWhite)
    }
    
    private func designButton(button: UIButton, title: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        config.title = title
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.pretendard(size: 16, weight: .semiBold)
        ]))
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0)
        button.configuration = config
    }
}
