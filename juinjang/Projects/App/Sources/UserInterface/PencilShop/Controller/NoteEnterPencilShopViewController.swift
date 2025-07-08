//
//  NoteEnterPencilShopViewController.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

import UIKit
import ReactorKit
import Then

final class NoteEnterPencilShopViewController: BaseViewController, View {
    private let mainView = NoteEnterPencilShopView()
    var disposeBag = DisposeBag()
    
    var onPurchaseCompleted: ((Bool) -> Void)?
    
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
            .compactMap { $0 }
            .distinctUntilChanged()
            .observe(on: MainScheduler.instance)
            .subscribe(with: self) { (owner, purchasePencilDTO) in
                guard let reactor = owner.reactor else { return }
                
                owner.mainView.setPencilCount(count: purchasePencilDTO.remainQuantity)
                
                if purchasePencilDTO.status == "SUCCESS" {
                    owner.onPurchaseCompleted?(true)
                }
                
                owner.present(NotePurchasePopupViewController(
                    buildingName: reactor.dependency.buildingName,
                    score: reactor.dependency.totalRate,
                    currentPencilCount: reactor.currentState.pencilTotalBalance?.totalBalance ?? 0,
                    neededPencilCount: reactor.dependency.needPencilCount
                ).then {
                    $0.eventRelay
                        .bind(onNext: { event in
                            switch event {
                            case .confirm:
                                owner.onPurchaseCompleted?(true)
                                owner.navigationController?.popViewController(animated: true)
                            default: break
                            }
                        })
                        .disposed(by: owner.disposeBag)
                }, animated: true)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.needPencilCount }
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, count in
                owner.mainView.setNeededPencilCount(count: count)
            }
            .disposed(by: disposeBag)
        
        reactor.state
            .map { $0.lackingPencilCount }
            .compactMap { $0 }
            .distinctUntilChanged()
            .subscribe(with: self) { owner, count in
                owner.mainView.setNotEnoughPencilCount(count: count)
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
