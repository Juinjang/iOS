//
//  LookAroundFilterHeader.swift
//  juinjang
//
//  Created by 조유진 on 3/9/25.
//

import UIKit
import RxSwift
import RxRelay

final class LookAroundFilterHeader: BaseCollectionReusableView {
    private let filterView = LookAroundDropDownView()
    private var disposeBag = DisposeBag()
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = DisposeBag()
    }
    
    func bind(relay: PublishRelay<LookAroundEventType>) {
        filterView.sortActionRelay
            .subscribe(with: self) { (self, action) in
                relay.accept(.filterItemTap(action, nil, nil))
            }
            .disposed(by: disposeBag)
        
        filterView.transactionTypeActionRelay
            .subscribe(with: self) { (self, action) in
                relay.accept(.filterItemTap(nil, action, nil))
            }
            .disposed(by: disposeBag)
        
        filterView.saleTypeActionRelay
            .subscribe(with: self) { (self, action) in
                relay.accept(.filterItemTap(nil, nil, action))
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        super.configureHierarchy()
        addSubview(filterView)
    }
    
    override func configureLayout() {
        super.configureLayout()
        filterView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(16)
            make.top.equalToSuperview()
            make.bottom.lessThanOrEqualToSuperview().inset(4)
            make.trailing.lessThanOrEqualToSuperview().inset(24)
        }
    }
    
    override func configureView() {
        super.configureView()
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
