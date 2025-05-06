//
//  ShareWritePhotoCell.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

import UIKit
import Then
import SnapKit
import RxSwift
import RxRelay

final class ShareWritePhotoCell: BaseCollectionViewCell {
    private let titleLabel = DSLabel(.title).then {
        $0.fontColor = .gray600
        $0.text = "건물명"
        $0.fontAlignment = .left
    }
    
    private let publicButton = SelectableButton(title: "공개")
    private let privateButton = SelectableButton(title: "비공개")
    
    private lazy var buttonStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.spacing = 9
        $0.distribution = .fillEqually
        $0.alignment = .fill
    }
    
    private var disposeBag = DisposeBag()
    
    func bind(item: Bool, relay: PublishRelay<Bool>) {
        publicButton.isSelected = item
        privateButton.isSelected = !item
        
        publicButton.rx.throttleTap
            .map { true }
            .bind(to: relay)
            .disposed(by: disposeBag)
        
        privateButton.rx.throttleTap
            .map { false }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        
        contentView.add(titleLabel, buttonStackView)
        
        [publicButton, privateButton].forEach { button in
            buttonStackView.addArrangedSubview(button)
        }
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.left.equalToSuperview().offset(24)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(12)
            $0.leading.trailing.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
    }
}


