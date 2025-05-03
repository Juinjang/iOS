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
        let storeKitService: StoreKitService
        let obtainedPencilRepository: ObtainedPencilRepositoryProtocol
        let purchasedPencilRepository: PurchasedPencilRepositoryProtocol
        let usedPencilRepository: UsedPencilRepositoryProtocol
    }
    
    let dependency: Dependency
    
    init(dependency: Dependency) {
        self.dependency = dependency
    }
    
    enum Action {
        case viewDidLoad
        case categoryButtonDidTap(Int)
        case priceButtonDidTap(Product)
    }
    
    enum Mutation {
        case setProductList([Product])
        case setObtainedList([ObtainedPencilModel])
        case setPurchasedList([PurchasedPencilModel])
        case setUsedList([UsedPencilModel])
        case purchaseCompleted(VerifiyTransactionResponse)
    }
    
    struct State {
        var products: [Product] = []
        var obtainedSections: [ObtainedSectionModel] = []
        var purchasedSections: [PurchasedSectionModel] = []
        var usedSections: [UsedSectionModel] = []
        var purchaseResult: VerifiyTransactionResponse?
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return handleCategoryTapped(index: PencilShopCategoryType.buying.rawValue)
        case .categoryButtonDidTap(let index):
            return handleCategoryTapped(index: index)
        case .priceButtonDidTap(let product):
            return buyProduct(product: product)
        }
    }
    
    func reduce(state: State, mutation: Mutation) -> State {
        var state = state
        switch mutation {
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
        }
        return state
    }
}

extension PencilShopReactor {
    private func handleCategoryTapped(index: Int) -> Observable<Mutation> {
        let category = PencilShopCategoryType(rawValue: index) ?? .buying
        
        switch category {
        case .buying:
            if !currentState.products.isEmpty { return .empty() }
            return dependency.storeKitService.requestProductList()
                .map { .setProductList($0) }
                .asObservable()
                
        case .obtainedPencil:
            return dependency.obtainedPencilRepository.fetchObtainedPencilList()
                .flatMap { obtainedList -> Observable<Mutation> in
                    return .just(.setObtainedList(obtainedList))
                }
            
        case .purchasedPencil:
            return dependency.purchasedPencilRepository.fetchPurchasedPencilList()
                .flatMap { purchasedList -> Observable<Mutation> in
                    return .just(.setPurchasedList(purchasedList))
                }
        case .usedPencil:
            return dependency.usedPencilRepository.fetchUsedPencilList()
                .flatMap { usedList -> Observable<Mutation> in
                    return .just(.setUsedList(usedList))
                }
        }
    }
    
    private func setObtainedSectionModel(state: inout State, obtainedList: [ObtainedPencilModel]) {
        state.obtainedSections = [ObtainedSectionModel(section: .main, obtainedPencils: obtainedList)]
    }
    
    private func setPurchasedSectionModel(state: inout State, purchasedList: [PurchasedPencilModel]) {
        state.purchasedSections = [PurchasedSectionModel(section: .main, obtainedPencils: purchasedList)]
    }
    
    private func setUsedSectionModel(state: inout State, usedList: [UsedPencilModel]) {
        state.usedSections = [UsedSectionModel(section: .main, usedPencils: usedList)]
    }
}

extension PencilShopReactor {
    private func buyProduct(product: Product) -> Observable<Mutation> {
        dependency.storeKitService.requestPurchase(product: product)
            .asObservable()
            .flatMap { _ in Observable.empty() }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        return dependency.storeKitService.transactionCompleted
            .map { Mutation.purchaseCompleted($0) }
    }
}

struct ObtainedSectionModel {
    let section: ObtainedPencilSection
    let obtainedPencils: [ObtainedPencilModel]
}

enum ObtainedPencilSection: Hashable {
    case main
}


struct PurchasedSectionModel {
    let section: PurchasedPencilSection
    let obtainedPencils: [PurchasedPencilModel]
}

enum PurchasedPencilSection: Hashable {
    case main
}

struct UsedSectionModel {
    let section: UsedPencilSection
    let usedPencils: [UsedPencilModel]
}

enum UsedPencilSection: Hashable {
    case main
}
