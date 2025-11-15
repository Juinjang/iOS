//
//  LookAroundDropDownView.swift
//  juinjang
//
//  Created by 조유진 on 3/13/25.
//

import UIKit
import RxRelay
import RxSwift

final class LookAroundDropDownView: BaseView {
    private let sortDropDownView = DropDownView(filterList: SortFilter.allCases)
    private let transactionTypeDropDownView = DropDownView(filterList: TransactionTypeFilter.allCases)
    private let saleTypeDropDownView = DropDownView(filterList: SaleTypeFilter.allCases)

    let sortActionRelay = PublishRelay<SortAction>()
    let transactionTypeActionRelay = PublishRelay<TransactionTypeAction>()
    let saleTypeActionRelay = PublishRelay<SaleTypeAction>()
    
    private var disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        bind()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func bind() {
        sortDropDownView.filterActionRelay
            .bind(with: self) { owner, action in
                owner.sortActionRelay.accept(action as! SortAction)
            }
            .disposed(by: disposeBag)
        
        transactionTypeDropDownView.filterActionRelay
            .bind(with: self) { owner, action in
                owner.transactionTypeActionRelay.accept(action as! TransactionTypeAction)
            }
            .disposed(by: disposeBag)
        
        saleTypeDropDownView.filterActionRelay
            .bind(with: self) { owner, action in
                owner.saleTypeActionRelay.accept(action as! SaleTypeAction)
            }
            .disposed(by: disposeBag)
    }
    
    override func configureHierarchy() {
        addSubview(sortDropDownView)
        addSubview(transactionTypeDropDownView)
        addSubview(saleTypeDropDownView)
    }
    override func configureLayout() {
        sortDropDownView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        
        transactionTypeDropDownView.snp.makeConstraints { make in
            make.leading.equalTo(sortDropDownView.snp.trailing)
            make.verticalEdges.equalToSuperview()
        }
        
        saleTypeDropDownView.snp.makeConstraints { make in
            make.leading.equalTo(transactionTypeDropDownView.snp.trailing)
            make.trailing.lessThanOrEqualToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
    override func configureView() { }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        // 우선, 기본 hitTest 결과를 확인
        if let hitView = super.hitTest(point, with: event) {
            return hitView
        }
        
        // DropDownView의 bounds 밖이라도 filterSelectStackView에 터치가 있는지 확인
        let convertedPoint = sortDropDownView.convert(point, from: self)
        if let hitView = sortDropDownView.hitTest(convertedPoint, with: event) {
            return hitView
        }
        
        let convertedPoint2 = transactionTypeDropDownView.convert(point, from: self)
        if let hitView = transactionTypeDropDownView.hitTest(convertedPoint2, with: event) {
            return hitView
        }
        
        let convertedPoint3 = saleTypeDropDownView.convert(point, from: self)
        if let hitView = saleTypeDropDownView.hitTest(convertedPoint3, with: event) {
            return hitView
        }
        
        return nil
    }
}
