//
//  BottomButtonView.swift
//  juinjang
//
//  Created by 조유진 on 3/20/25.
//

import UIKit
import RxRelay
import RxSwift

final class BottomButtonView: UIStackView {
    private let cancelButton = UIButton()
    private let confirmButton = UIButton()
    
    let cancelButtonTapRelay = PublishRelay<Void>()
    let confirmButtonTapRelay = PublishRelay<Void>()
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        cancelButton.rx.throttleTap
            .subscribe(with: self) { owner, _ in
                owner.cancelButtonTapRelay.accept(())
            }
            .disposed(by: disposeBag)
        
        confirmButton.rx.throttleTap
            .subscribe(with: self) { owner, _ in
                owner.confirmButtonTapRelay.accept(())
            }
            .disposed(by: disposeBag)
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
        
        designButton(button: cancelButton, title: "취소", backgroundColor: .gray3, foregroundColor: .gray500)
        designButton(button: confirmButton, title: "확인", backgroundColor: .main, foregroundColor: .mainWhite)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        layer.shadowRadius = 16
        layer.shadowOpacity = 0.08
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.masksToBounds = false

        let shadowHeight: CGFloat = layer.shadowRadius
        let pathRect = CGRect(x: 0,
                              y: -shadowHeight / 2,
                              width: bounds.width,
                              height: shadowHeight)
        layer.shadowPath = UIBezierPath(rect: pathRect).cgPath
    }
    
    private func designButton(button: UIButton, title: String, backgroundColor: UIColor, foregroundColor: UIColor) {
        var config = UIButton.Configuration.plain()
        config.background.backgroundColor = backgroundColor
        config.baseForegroundColor = foregroundColor
        config.attributedTitle = AttributedString(title, attributes: AttributeContainer([
            .font: UIFont.pretendard(size: 16, weight: .semiBold)
        ]))
        config.background.cornerRadius = 10
        config.contentInsets = NSDirectionalEdgeInsets(top: 15, leading: 0, bottom: 15, trailing: 0)
        button.configuration = config
    }
}
