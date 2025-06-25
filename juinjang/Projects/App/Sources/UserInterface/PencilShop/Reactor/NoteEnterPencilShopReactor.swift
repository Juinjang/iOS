//
//  NoteEnterPencilShopReactor.swift
//  juinjang
//
//  Created by 조유진 on 6/17/25.
//

import ReactorKit
import Foundation
import StoreKit

final class NoteEnterPencilShopReactor: Reactor {
    var initialState = State()
    
    struct Dependency {
        let inAppPurchaseService: InAppPurchaseService
        let pencilShopRepository: PencilShopRepositoryProtocol
    }
    
    private let dependency: Dependency
    private var disposeBag = DisposeBag()
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case viewDidLoad
        case priceButtonDidTap(Product)
    }
    
    enum Mutation {
        case setPencilTotalBalance(PencilBalanceDTO)
        case setProductList([Product])
        case purchaseCompleted(PurchasePencilDTO?)
        case purchaseFailed(Error)
    }
    
    struct State {
        var pencilTotalBalance: PencilBalanceDTO?
        var products: [Product] = []
        var purchaseResult: PurchasePencilDTO?
        var error: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                retrievePencilTotalBalance(),
                retrieveProductList()
            ])
        case .priceButtonDidTap(let product):
            return buyProduct(product: product)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPencilTotalBalance(let pencilTotalBalance):
            state.pencilTotalBalance = pencilTotalBalance
        case .setProductList(let array):
            state.products = array
        case .purchaseCompleted(let result):
            state.purchaseResult = result
        case .purchaseFailed(let error):
            state.error = error.localizedDescription
        }
        return state
    }
}

extension NoteEnterPencilShopReactor {
    private func retrievePencilTotalBalance() -> Observable<Mutation> {
        return dependency.pencilShopRepository.retrievePencilTotalBalance()
            .asObservable()
            .flatMap { totalBalanceDTO -> Observable<Mutation> in
                return .just(.setPencilTotalBalance(totalBalanceDTO))
            }
    }
    
    private func retrieveProductList() -> Observable<Mutation> {
        if !currentState.products.isEmpty { return .empty() }
        return dependency.inAppPurchaseService.requestProductList()
            .map { .setProductList($0) }
            .asObservable()
    }
}

extension NoteEnterPencilShopReactor {
    private func buyProduct(product: Product) -> Observable<Mutation> {
        dependency.inAppPurchaseService.requestPurchase(product: product)
            .asObservable()
            .flatMap { result -> Observable<Mutation> in
                guard let result else {
                    return .just(.purchaseFailed(StoreError.failedPurchase))
                }
                return .just(.purchaseCompleted(result))
            }
            .catch { error -> Observable<Mutation> in
                return .just(.purchaseFailed(error))
           }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let transactionMutation = dependency.inAppPurchaseService.completedPurchasePencilDTO
            .map { Mutation.purchaseCompleted($0) }

        return Observable.merge(mutation, transactionMutation)
    }
}
