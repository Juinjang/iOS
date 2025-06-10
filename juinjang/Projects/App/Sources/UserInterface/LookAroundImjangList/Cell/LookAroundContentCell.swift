//
//  LookAroundContentCell.swift
//  juinjang
//
//  Created by 조유진 on 3/1/25.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa

final class LookAroundContentCell: BaseCollectionViewCell {
    private let iconImageView = UIImageView().then {
        $0.image = nil
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel()
    
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        disposeBag = DisposeBag()
    }
    
    func configureCell(content: LookAroundContent,
                       relay: PublishRelay<String>) {
        iconImageView.image = content.iconImage
        titleLabel.setAttribute(text: content.title, color: .gray600, font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
        
        contentView.rx.tapGesture
            .bind(onNext: { _ in
                relay.accept(content.title)
            })
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [iconImageView, titleLabel].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        iconImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(10)
            make.size.equalTo(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.bottom.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(10)
            make.trailing.lessThanOrEqualToSuperview().inset(10)
        }
    }
    
    override func configureView() {
        layer.masksToBounds = false
        layer.cornerRadius = 8
        
        contentView.layer.cornerRadius = 8
        contentView.clipsToBounds = true
        
        backgroundColor = .gray100
    }
}
