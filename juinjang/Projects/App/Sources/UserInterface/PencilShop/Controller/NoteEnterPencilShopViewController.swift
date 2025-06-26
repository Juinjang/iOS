//
//  NoteEnterPencilShopViewController.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

import UIKit
import ReactorKit

final class NoteEnterPencilShopViewController: BaseViewController, View {
    private let mainView = NoteEnterPencilShopView()
    var disposeBag = DisposeBag()
    
    init(reactor: NoteEnterPencilShopReactor) {
        super.init()
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewEvent()
        reactor?.action.onNext(.viewDidLoad)
    }
    
    func bind(reactor: NoteEnterPencilShopReactor) {
        reactor.state
            .compactMap { $0.pencilTotalBalance }
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, pencilBalanceDTO in
                owner.mainView.setPencilCount(count: pencilBalanceDTO.totalBalance)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .compactMap { $0.products }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, products in
                owner.mainView.setProductList(products)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.purchaseResult }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .bind(with: self) { owner, purchasePencilDTO in
                guard let purchasePencilDTO else { return }
                // notePurchasePopupViewController.present
                owner.mainView.setPencilCount(count: purchasePencilDTO.remainQuantity)
            }
            .disposed(by: disposeBag)
    }
    
    func bindViewEvent() {
        mainView
            .navigationView
            .itemActionRelay
            .withUnretained(self)
            .subscribe { (self, action) in
                switch action {
                case .popButtonTap:
                    self.navigationController?.popViewController(animated: true)
                default: break
                }
            }
            .disposed(by: disposeBag)
        
        mainView.priceTappedRelay
            .map {
                return Reactor.Action.priceButtonDidTap($0)
            }
            .bind(to: reactor!.action)
            .disposed(by: disposeBag)
    }
    
    override func loadView() {
        view = mainView
    }
}
