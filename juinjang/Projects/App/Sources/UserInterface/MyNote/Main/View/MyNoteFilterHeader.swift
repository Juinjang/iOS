//
//  MyNoteFilterCell.swift
//  juinjang
//
//  Created by KimDongWoo on 3/14/25.
//

import UIKit
import SnapKit
import RxSwift
import RxRelay
import RxCocoa
import Then

final class MyNoteFilterHeader: BaseView {
    private var disposeBag = DisposeBag()
    private let noticeView = MyNoteNoticeView()
    private let filterView = MyNoteDropDownView()
    private var heightConstraint: Constraint?
    private let closeButtonTapRelay = PublishRelay<Void>()
        
    func configure(pageModel: MyNotePageModel,
                   relay: PublishRelay<MyNotePageEventType>) {
        applyLayout(isExpanded: pageModel.isShowingNotice)
        noticeView.configure(pageModel.category, relay: closeButtonTapRelay)
        filterView.configure(pageModel.transactionType, pageModel.saleType)
        
        closeButtonTapRelay
            .withUnretained(self)
            .subscribe { (self, _) in
                self.animateNoticeClose(category: pageModel.category, relay: relay)
            }
            .disposed(by: disposeBag)
        
        filterView.transactionTypeActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                relay.accept(.filterItemTap(action, nil))
            }
            .disposed(by: disposeBag)
        
        filterView.saleTypeActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                relay.accept(.filterItemTap(nil, action))
            }
            .disposed(by: disposeBag)
    }
    
    func prepareForReuse() {
        disposeBag = DisposeBag()
        noticeView.alpha = 1.0
        noticeView.isHidden = false
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        add(
            noticeView,
            filterView
        )
    }
    
    override func configureLayout() {
        super.configureLayout()
        
        self.snp.makeConstraints {
            self.heightConstraint = $0.height.equalTo(115).constraint
        }
        
        noticeView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.top.equalToSuperview().offset(16)
            $0.horizontalEdges.equalToSuperview()
        }
        
        filterView.snp.makeConstraints {
            $0.height.equalTo(35)
            $0.top.equalTo(noticeView.snp.bottom).offset(8)
            $0.left.equalToSuperview().inset(24)
        }
    }
    
    private func animateNoticeClose(category: MyNoteCategoryType,
                                    relay: PublishRelay<MyNotePageEventType>) {
        guard let superview = self.superview else { return }
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: []) {
            UIView.addKeyframe(withRelativeStartTime: 0.0, relativeDuration: 0.5) {
                self.noticeView.alpha = 0.0
            }
            UIView.addKeyframe(withRelativeStartTime: 0.3, relativeDuration: 0.7) {
                self.heightConstraint?.update(offset: 51)
                self.updateConstraints(isExpanded: false)
                superview.layoutIfNeeded()
            }
        } completion: { [weak self] _ in
            guard let self = self else { return }
            self.noticeView.isHidden = true
            relay.accept(.noticeCloseButtonTap)
        }
    }
    
    private func applyLayout(isExpanded: Bool) {
        noticeView.isHidden = !isExpanded
        heightConstraint?.update(offset: isExpanded ? 115 : 51)
        updateConstraints(isExpanded: isExpanded)
        
        superview?.layoutIfNeeded()
    }
    
    private func updateConstraints(isExpanded: Bool) {
        if isExpanded {
            noticeView.snp.remakeConstraints {
                $0.height.equalTo(48)
                $0.top.equalToSuperview().offset(16)
                $0.horizontalEdges.equalToSuperview()
            }
            
            filterView.snp.remakeConstraints {
                $0.height.equalTo(35)
                $0.top.equalTo(noticeView.snp.bottom).offset(8)
                $0.left.equalToSuperview().inset(24)
            }
        } else {
            filterView.snp.remakeConstraints {
                $0.top.equalToSuperview().offset(8)
                $0.left.equalToSuperview().inset(24)
                $0.height.equalTo(35)
            }
        }
    }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            return hitView
        }
        
        let convertedPoint = filterView.convert(point, from: self)
        if let hitView = filterView.hitTest(convertedPoint, with: event) {
            return hitView
        }
        
        return nil
    }
}
