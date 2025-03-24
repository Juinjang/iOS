//
//  MyNoteDropDownView.swift
//  juinjang
//
//  Created by KimDongWoo on 3/23/25.
//

import UIKit
import RxRelay
import RxSwift
import RxCocoa
import SnapKit

final class MyNoteDropDownView: BaseView {
    private let transactionTypeDropDownView = DropDownView(filterList: TransactionTypeFilter.allCases)
    private let saleTypeDropDownView = DropDownView(filterList: SaleTypeFilter.allCases)

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
    
    func configure(_ transactionType: TransactionTypeFilter,
                   _ saleType: SaleTypeFilter) {
        transactionTypeDropDownView.configureSelectedFilter(transactionType)
        saleTypeDropDownView.configureSelectedFilter(saleType)
    }
    
    private func bind() {
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
        addSubview(transactionTypeDropDownView)
        addSubview(saleTypeDropDownView)
    }
    
    override func configureLayout() {
        transactionTypeDropDownView.snp.makeConstraints { make in
            make.leading.verticalEdges.equalToSuperview()
        }
        
        saleTypeDropDownView.snp.makeConstraints { make in
            make.leading.equalTo(transactionTypeDropDownView.snp.trailing)
            make.trailing.lessThanOrEqualToSuperview()
            make.verticalEdges.equalToSuperview()
        }
    }
    
    override func configureView() { }
    
    override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let hitView = super.hitTest(point, with: event) {
            return hitView
        }
        
        let convertedPointTransaction = transactionTypeDropDownView.convert(point, from: self)
        if let hitView = transactionTypeDropDownView.hitTest(convertedPointTransaction, with: event) {
            return hitView
        }
        
        let convertedPointSale = saleTypeDropDownView.convert(point, from: self)
        if let hitView = saleTypeDropDownView.hitTest(convertedPointSale, with: event) {
            return hitView
        }
        
        return nil
    }
}
