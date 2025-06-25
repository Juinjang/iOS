//
//  PencilShopReactor.swift
//  juinjang
//
//  Created by 조유진 on 4/1/25.
//

import ReactorKit
import Foundation
import StoreKit

final class PencilShopReactor: Reactor {
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
        case categoryButtonDidTap(Int)
        case priceButtonDidTap(Product)
    }
    
    enum Mutation {
        case setPencilTotalBalance(PencilBalanceDTO)
        case setIsTotalRead(IsTotalReadAcquiredPencilDTO)
        case setProductList([Product])
        case setObtainedList([AcquiredPencilDTO])
        case setPurchasedList([PurchasedPencilDTO])
        case setUsedList([UsedPencilDTO])
        case purchaseCompleted(PurchasePencilDTO?)
        case purchaseFailed(Error)
    }
    
    struct State {
        var pencilTotalBalance: PencilBalanceDTO?
        var isTotalRead: IsTotalReadAcquiredPencilDTO?
        var products: [Product] = []
        var obtainedSections: [ObtainedSectionModel] = []
        var purchasedSections: [PurchasedSectionModel] = []
        var usedSections: [UsedSectionModel] = []
        var purchaseResult: PurchasePencilDTO?
        var error: String?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                retrievePencilTotalBalance(),
                retrieveIsTotalRead(),
                handleCategoryTapped(index: PencilShopCategoryType.buying.rawValue)
            ])
        case .categoryButtonDidTap(let index):
            return handleCategoryTapped(index: index)
        case .priceButtonDidTap(let product):
            return buyProduct(product: product)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
        case .setPencilTotalBalance(let pencilTotalBalance):
            state.pencilTotalBalance = pencilTotalBalance
        case .setIsTotalRead(let isTotalReadDTO):
            state.isTotalRead = isTotalReadDTO
        case .setProductList(let array):
            state.products = array
        case .setObtainedList(let array):
            setObtainedSectionModel(state: &state, obtainedList: array)
        case .setPurchasedList(let array):
            setPurchasedSectionModel(state: &state, purchasedList: array)
        case .setUsedList(let array):
            setUsedSectionModel(state: &state, usedList: array)
        case .purchaseCompleted(let result):
            state.purchaseResult = result
        case .purchaseFailed(let error):
            state.error = error.localizedDescription
        }
        return state
    }
}

extension PencilShopReactor {
    private func retrievePencilTotalBalance() -> Observable<Mutation> {
        return dependency.pencilShopRepository.retrievePencilTotalBalance()
            .asObservable()
            .flatMap { totalBalanceDTO -> Observable<Mutation> in
                return .just(.setPencilTotalBalance(totalBalanceDTO))
            }
    }
    
    private func retrieveIsTotalRead() -> Observable<Mutation> {
        return dependency.pencilShopRepository.retrieveIsTotalReadAcquiredPencil()
            .asObservable()
            .flatMap { isTotalReadDTO -> Observable<Mutation> in
                return .just(.setIsTotalRead(isTotalReadDTO))
            }
    }
    
    private func handleCategoryTapped(index: Int) -> Observable<Mutation> {
        let category = PencilShopCategoryType(rawValue: index) ?? .buying
        
        switch category {
        case .buying:
            if !currentState.products.isEmpty { return .empty() }
            return dependency.inAppPurchaseService.requestProductList()
                .map { .setProductList($0) }
                .asObservable()
                
        case .obtainedPencil:
            return dependency.pencilShopRepository.retrieveAcquiredPencil()
                .asObservable()
                .flatMap { obtainedList -> Observable<Mutation> in
                    return .just(.setObtainedList(obtainedList))
                }
            
        case .purchasedPencil:
            return dependency.pencilShopRepository.retrievePurchasedPencil()
                .asObservable()
                .flatMap { purchasedList -> Observable<Mutation> in
                    return .just(.setPurchasedList(purchasedList))
                }
        case .usedPencil:
            return dependency.pencilShopRepository.retrieveUsedPencil()
                .asObservable()
                .flatMap { usedList -> Observable<Mutation> in
                    return .just(.setUsedList(usedList))
                }
        }
    }
    
    private func setObtainedSectionModel(state: inout State, obtainedList: [AcquiredPencilDTO]) {
        state.obtainedSections = [ObtainedSectionModel(section: .main, obtainedPencils: obtainedList)]
    }
    
    private func setPurchasedSectionModel(state: inout State, purchasedList: [PurchasedPencilDTO]) {
        state.purchasedSections = [PurchasedSectionModel(section: .main, purchasedPencils: purchasedList)]
    }
    
    private func setUsedSectionModel(state: inout State, usedList: [UsedPencilDTO]) {
        state.usedSections = [UsedSectionModel(section: .main, usedPencils: usedList)]
    }
}

extension PencilShopReactor {
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

struct ObtainedSectionModel {
    let section: ObtainedPencilSection
    let obtainedPencils: [AcquiredPencilDTO]
}

enum ObtainedPencilSection: Hashable {
    case main
}


struct PurchasedSectionModel {
    let section: PurchasedPencilSection
    let purchasedPencils: [PurchasedPencilDTO]
}

enum PurchasedPencilSection: Hashable {
    case main
}

struct UsedSectionModel {
    let section: UsedPencilSection
    let usedPencils: [UsedPencilDTO]
}

enum UsedPencilSection: Hashable {
    case main
}
