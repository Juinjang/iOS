//
//  LookAroundContentCell.swift
//  juinjang
//
//  Created by 조유진 on 3/1/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay

enum LookAroundCellEventType: Equatable {
    case cellContentTap(content: LookAroundContent)
}

extension LookAroundCellEventType {
    var tappedContent: LookAroundContent? {
        if case let .cellContentTap(content) = self {
            return content
        }
        return nil
    }
}

final class LookAroundContentCell: BaseCollectionViewCell {
    private let iconImageView = UIImageView().then {
        $0.image = nil
        $0.contentMode = .scaleAspectFit
    }
    
    private let titleLabel = UILabel()
    let cellTapButton = UIButton().then {
        $0.backgroundColor = .clear
    }
 
    var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
        iconImageView.image = nil
    }
    
    func configureCell(content: LookAroundContent, relay: PublishRelay<LookAroundCellEventType>) {
        iconImageView.image = content.iconImage
        titleLabel.setAttribute(text: content.title, color: .gray600, font: .pretendard(size: 16, weight: .semiBold), lineHeight: 23)
        
        cellTapButton.rx.tap
            .map { LookAroundCellEventType.cellContentTap(content: content) }
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        [iconImageView, titleLabel, cellTapButton].forEach {
            contentView.addSubview($0)
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
        
        cellTapButton.snp.makeConstraints { make in
            make.edges.equalToSuperview()
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
