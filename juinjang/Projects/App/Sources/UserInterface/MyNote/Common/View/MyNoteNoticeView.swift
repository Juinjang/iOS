//
//  MyNoteNoticeView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit
import Then
import SnapKit
import RxRelay
import RxCocoa
import RxSwift

final class MyNoteNoticeView: BaseView {
    private let baseView = UIView().then {
        $0.backgroundColor = .gray100
        $0.layer.cornerRadius = 4
        $0.layer.masksToBounds = true
    }
    
    private let iconImageView = UIImageView()
    
    private let noticeLabel = BodyLabel().then {
        $0.fontColor = .gray400
        $0.fontSize = 14
        $0.lineHeight = 20.3
        $0.letterSpacing = -0.2
    }
    
    private let closeButton = ImageButton(normalImage: .x24).then {
        $0.tintColor = .gray300
    }
    
    private var disposeBag = DisposeBag()
    
    func configure(_ category: MyNoteCategoryType,
                   relay: PublishRelay<Void>) {
        disposeBag = DisposeBag()
        applyLayoutFor(category)
        
        closeButton.rx.tap
            .bind(to: relay)
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add([
            baseView.with(
                iconImageView,
                noticeLabel,
                closeButton
            )
        ])
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        baseView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview()
        }
        
        iconImageView.snp.makeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        
        noticeLabel.snp.makeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
        
        closeButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.right.equalToSuperview().offset(-12)
            $0.size.equalTo(24)
        }
    }
    
    private func applyLayoutFor(_ category: MyNoteCategoryType) {
        switch category {
        case .share:
            applyLayoutForShare()
        case .own:
            applyLayoutForOwn()
        case .like:
            applyLayoutForLike()
        }
    }
    
    private func applyLayoutForShare() {
        noticeLabel.text = "여기서는 내가 공유한 노트를 볼 수 있어요."
        iconImageView.image = nil
        
        iconImageView.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(0)
            $0.height.equalTo(0)
        }
        
        noticeLabel.snp.remakeConstraints {
            $0.left.equalTo(iconImageView.snp.right)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func applyLayoutForOwn() {
        noticeLabel.text = "여기서는 내가 소장한 노트를 볼 수 있어요."
        iconImageView.image = .circlePencil
        
        iconImageView.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(28)
        }
        
        noticeLabel.snp.remakeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
    
    private func applyLayoutForLike() {
        noticeLabel.text = "여기서는 좋아요를 누른 노트를 볼 수 있어요."
        iconImageView.image = .noticeHeart
        
        iconImageView.snp.remakeConstraints {
            $0.left.equalToSuperview().offset(12)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(24)
            $0.height.equalTo(20)
        }
        
        noticeLabel.snp.remakeConstraints {
            $0.left.equalTo(iconImageView.snp.right).offset(8)
            $0.centerY.equalToSuperview()
        }
    }
}
