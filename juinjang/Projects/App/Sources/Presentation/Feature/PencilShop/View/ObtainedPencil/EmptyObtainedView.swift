//
//  EmptyObtainedView.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import UIKit
import Then
import SnapKit

final class EmptyObtainedView: UIStackView {
    private let imageView = UIImageView().then {
        $0.image = .emptyPencil
        $0.contentMode = .scaleAspectFit
    }
    
    private let descriptionLabel = UILabel().then {
        $0.setAttribute(
            text: "아직 얻은 연필이 없어요\n내 노트를 나누고 무료 연필을 얻어보세요!",
            color: .gray400,
            font: .pretendard(size: 16, weight: .medium),
            lineHeight: 23,
            charSpacing: -0.02,
            alignment: .center
        )
        $0.numberOfLines = 0
    }
    
    let goMyImjangNoteButton = UIButton().then {
        var config = UIButton.Configuration.plain()
        config.attributedTitle = AttributedString("내 임장노트로 가기", attributes: AttributeContainer([
            .font: UIFont.pretendard(size: 16, weight: .semiBold),
            .foregroundColor: UIColor.mainWhite,
        ]))
        config.titleAlignment = .center
        config.background.backgroundColor = .gray500
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 24, bottom: 15, trailing: 24)
        
        $0.configuration = config
    }
    
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
        [imageView, descriptionLabel, goMyImjangNoteButton].forEach {
            self.addArrangedSubview($0)
        }
    }
    
    private func configureLayout() {
        self.setCustomSpacing(8, after: imageView)
        self.setCustomSpacing(36, after: descriptionLabel)
        
        imageView.snp.makeConstraints { make in
            make.width.equalTo(234)
            make.height.equalTo(154)
        }
    }
    
    private func configureView() {
        axis = .vertical
        alignment = .center
        distribution = .fill
    }
}
