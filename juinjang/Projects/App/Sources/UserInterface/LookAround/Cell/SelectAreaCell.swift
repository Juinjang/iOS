//
//  SelectAreaCell.swift
//  juinjang
//
//  Created by 조유진 on 3/1/25.
//

import UIKit
import RxSwift
import RxRelay

final class SelectAreaCell: BaseCollectionViewCell {
    private let selectBackgroundView = UIView().then {
        $0.backgroundColor = .clear
        $0.layer.borderColor = UIColor.stroke.cgColor
        $0.layer.borderWidth = 1
        $0.layer.cornerRadius = 10
    }
    
    private let messageStackView = UIStackView().then {
        $0.design(spacing: 4)
    }
    
    private let iconImageView = UIImageView().then {
        $0.image = UIImage.ImjangNote.location.withTintColor(.main200)
        $0.contentMode = .scaleAspectFit
    }
    
    private let messageLabel = UILabel()
    
    private let selectLabel = UILabel().then {
        $0.setAttribute(text: "선택", color: .gray450, font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
    }
    
    private let cellButton = UIButton()
    private var disposeBag = DisposeBag()
    
    func configureCell(areaString: String?, relay: PublishRelay<LookAroundEventType>) {
        if let areaString {
            iconImageView.image = UIImage.ImjangNote.location.withTintColor(.main)
            messageLabel.setAttribute(text: areaString, color: .main, font: .pretendard(size: 15, weight: .medium), lineHeight: 20)
        } else {
            iconImageView.image = UIImage.ImjangNote.location.withTintColor(.main200)
            messageLabel.setAttribute(text: "지역을 선택해주세요", color: .gray400, font: .pretendard(size: 14, weight: .medium), lineHeight: 20)
        }
        
        cellButton.rx.throttleTap
            .map { LookAroundEventType.selectAreaTap }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        iconImageView.image = nil
    }
    
    override func configureHierarchy() {
        [iconImageView, messageLabel].forEach {
            messageStackView.addArrangedSubview($0)
        }
        
        [messageStackView, selectLabel].forEach {
            selectBackgroundView.addSubview($0)
        }
        
        contentView.add(selectBackgroundView, cellButton)
    }
    
    override func configureLayout() {
        cellButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        selectBackgroundView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(0)
            make.horizontalEdges.equalToSuperview()
        }
        
        messageStackView.snp.makeConstraints { make in
            make.verticalEdges.leading.equalToSuperview().inset(12)
            make.trailing.lessThanOrEqualTo(selectLabel).inset(12)
        }
        
        selectLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(14)
            make.trailing.equalToSuperview().inset(12)
        }
        
        iconImageView.snp.makeConstraints { make in
            make.size.equalTo(24)
        }
    }
    
    override func configureView() {
        super.configureView()
    }
}
