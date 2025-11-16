//
//  UpdateAlertView.swift
//  juinjang
//
//  Created by 박도연 on 12/13/24.
//

import UIKit

public final class UpdateAlertView: UIView {
    public var updateButtonTappedAction: (() -> Void)?
    public var closeButtonTappedAction: (() -> Void)?
    
    private let backgroundImage = UIImageView().then {
        $0.image = UIImage.updateBackground
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false  // 오토 레이아웃을 사용할 경우 필요
    }
    
    private let peopleImage = UIImageView().then {
        $0.image = UIImage.OpenNewPage.userMovingInDirectly
        $0.contentMode = .scaleAspectFit
        $0.translatesAutoresizingMaskIntoConstraints = false  // 오토 레이아웃을 사용할 경우 필요
    }
    
    private let titleLabel = UILabel().then {
        $0.text = "우리 업데이트 하러갈까요?"
        $0.textColor = .main
        $0.font = .pretendard(size: 20, weight: .semiBold)
        $0.textAlignment = .center
    }
    
    private let descriptionLabel = UILabel().then {
        $0.text = "주인장 크루들이 오류와 사용성을 개선했어요.\n지금 바로 레벨업한 주인장을 확인해보세요!"
        let attrString = NSMutableAttributedString(string: $0.text!)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineHeightMultiple = 1.22
        attrString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attrString.length))
        $0.attributedText = attrString
        $0.textColor = .gray600
        $0.font = .pretendard(size: 16, weight: .medium)
        $0.textAlignment = .center
        $0.numberOfLines = 0
    }
    
    private let updateButton = UIButton(type: .system).then {
        $0.setTitle("업데이트하러 가기", for: .normal)
        $0.titleLabel?.font = .pretendard(size: 15, weight: .semiBold)
        $0.layer.cornerRadius = 10
        $0.backgroundColor = .gray500
        $0.setTitleColor(.mainWhite, for: .normal)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.backgroundColor = .mainWhite
        self.layer.cornerRadius = 10
        self.clipsToBounds = true
        
        addSubview(backgroundImage)
        addSubview(peopleImage)
        addSubview(titleLabel)
        addSubview(descriptionLabel)
        addSubview(updateButton)
        
        autoLayout()
        
        updateButton.addTarget(self, action: #selector(updateButtonTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func autoLayout() {
        backgroundImage.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.right.equalToSuperview()
        }
        peopleImage.snp.makeConstraints {
            $0.top.equalToSuperview().offset(59)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(56)
        }
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(peopleImage.snp.bottom).offset(21.38)
            $0.centerX.equalToSuperview()
        }
        descriptionLabel.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(16)
            $0.centerX.equalToSuperview()
        }
        updateButton.snp.makeConstraints {             
            $0.bottom.equalToSuperview().inset(13)
            $0.left.right.equalToSuperview().inset(12)
            $0.height.equalTo(52)
        }
    }

    
    @objc private func updateButtonTapped() {
        updateButtonTappedAction?()
    }
    
    @objc private func closeButtonTapped() {
        closeButtonTappedAction?()
    }
    
}
