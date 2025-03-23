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
    private let filterView = LookAroundDropDownView()
    private let closeButtonDidTap = PublishRelay<Void>()
    private var heightConstraint: Constraint?
    
    func configure(category: MyNoteCategoryType) {
        disposeBag = DisposeBag()
        noticeView.bind(category: category, relay: closeButtonDidTap)
        
        closeButtonDidTap
            .asDriver(onErrorJustReturn: ())
            .drive(with: self) { (self, _) in
                self.updateLayoutWithAnimation(isExpanded: false)
            }
            .disposed(by: disposeBag)
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
    
    private func updateLayoutWithAnimation(isExpanded: Bool) {
        guard let superview = self.superview else { return }
        
        UIView.animateKeyframes(withDuration: 0.5, delay: 0, options: [], animations: {
            UIView.addKeyframe(withRelativeStartTime: 0.0,
                               relativeDuration: 0.5) {
                self.noticeView.alpha = 0.0
            }
            
            UIView.addKeyframe(withRelativeStartTime: 0.3,
                               relativeDuration: 0.7) {
                self.heightConstraint?.update(offset: 51)
                self.updateConstraints(isExpanded: false)
                superview.layoutIfNeeded()
            }
        }, completion: { _ in
            if !isExpanded {
                self.noticeView.isHidden = true
            }
        })
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
}
