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
        let userRepository: UserRepositoryProtocol
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
        case acquiredPencilSelected(Int)
    }
    
    enum Mutation {
        case setPencilTotalBalance(PencilBalanceDTO)
        case setIsTotalRead(Bool)
        case setProductList([Product])
        case setAcquiredList([AcquiredPencilDTO])
        case setPurchasedList([PurchasedPencilDTO])
        case setUsedList([UsedPencilDTO])
        case purchaseCompleted(PurchasePencilDTO?)
        case purchaseFailed(Error)
        case setLoading(Bool)
    }
    
    struct State {
        var pencilTotalBalance: PencilBalanceDTO?
        var isTotalRead: Bool = false
        var products: [Product] = []
        var acquiredSections: [AcquiredSectionModel] = []
        var purchasedSections: [PurchasedSectionModel] = []
        var usedSections: [UsedSectionModel] = []
        var purchaseResult: PurchasePencilDTO?
        var error: String?
        var isLoading: Bool = false
    }
    
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .viewDidLoad:
            return .concat([
                .just(.setLoading(true)),
                retrievePencilTotalBalance(),
                retrieveIsTotalRead(),
                handleCategoryTapped(index: PencilShopCategoryType.buying.rawValue)
            ])
        case .categoryButtonDidTap(let index):
            return .concat(
                .just(.setLoading(true)),
                handleCategoryTapped(index: index)
            )
        case .priceButtonDidTap(let product):
            return buyProduct(product: product)
        case .acquiredPencilSelected(let selectedIndex):
            return handleAquiredPencilSelected(selectedIndex: selectedIndex)
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
        case .setAcquiredList(let array):
            setAcquiredSectionModel(state: &state, acquiredList: array)
        case .setPurchasedList(let array):
            setPurchasedSectionModel(state: &state, purchasedList: array)
        case .setUsedList(let array):
            setUsedSectionModel(state: &state, usedList: array)
        case .purchaseCompleted(let result):
            state.purchaseResult = result
        case .purchaseFailed(let error):
            state.error = error.localizedDescription
        case .setLoading(let bool):
            state.isLoading = bool
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
                return .just(.setIsTotalRead(isTotalReadDTO.isTotalRead))
            }
    }
    
    private func handleCategoryTapped(index: Int) -> Observable<Mutation> {
        let category = PencilShopCategoryType(rawValue: index) ?? .buying
        
        let mutationStream: Observable<Mutation>
        
        switch category {
        case .buying:
            if !currentState.products.isEmpty {
                return .just(.setLoading(false))
            }
            mutationStream = dependency.inAppPurchaseService.requestProductList()
                .map { .setProductList($0) }
                .asObservable()
            
        case .obtainedPencil:
            mutationStream = dependency.pencilShopRepository.retrieveAcquiredPencil()
                .asObservable()
                .map { .setAcquiredList($0) }
            
        case .purchasedPencil:
            mutationStream = dependency.pencilShopRepository.retrievePurchasedPencil()
                .asObservable()
                .map { .setPurchasedList($0) }
            
        case .usedPencil:
            mutationStream = dependency.pencilShopRepository.retrieveUsedPencil()
                .asObservable()
                .map { .setUsedList($0) }
        }
        
        return Observable.concat([
            mutationStream
                .catch { error in
                    return .just(.setLoading(false))
                },
            .just(.setLoading(false))
        ])
    }
    
    private func setAcquiredSectionModel(state: inout State, acquiredList: [AcquiredPencilDTO]) {
        state.acquiredSections = [AcquiredSectionModel(section: .main, acquiredPencils: acquiredList)]
    }
    
    private func setPurchasedSectionModel(state: inout State, purchasedList: [PurchasedPencilDTO]) {
        state.purchasedSections = [PurchasedSectionModel(section: .main, purchasedPencils: purchasedList)]
    }
    
    private func setUsedSectionModel(state: inout State, usedList: [UsedPencilDTO]) {
        state.usedSections = [UsedSectionModel(section: .main, usedPencils: usedList)]
    }
    
    private func handleAquiredPencilSelected(selectedIndex: Int) -> Observable<Mutation> {
        let sectionModel = currentState.acquiredSections[0]
        var acquiredPencils = sectionModel.acquiredPencils
        var selectedAquiredPencil = acquiredPencils[selectedIndex]
        
        guard !selectedAquiredPencil.read else { return .empty() }
        
        selectedAquiredPencil.read = true
        acquiredPencils[selectedIndex] = selectedAquiredPencil
        
        return dependency.pencilShopRepository.readAcquiredPencil(acquiredPencilId: selectedAquiredPencil.acquiredPencilId)
            .asObservable()
            .flatMap { readAcquiredPencilDTO -> Observable<Mutation> in
                return .concat([
                    .just(.setAcquiredList(acquiredPencils)),
                    .just(.setIsTotalRead(readAcquiredPencilDTO.isTotalRead))
                ])
            }
    }
}

extension PencilShopReactor {
    private func buyProduct(product: Product) -> Observable<Mutation> {
        dependency.userRepository.regenerateAccesstoken()
            .asObservable()
            .subscribe(with: self) { owner, refreshDTO in
                UserDefaultManager.shared.accessToken = refreshDTO.accessToken
                UserDefaultManager.shared.refreshToken = refreshDTO.refreshToken
            }
            .disposed(by: disposeBag)
        
        return dependency.inAppPurchaseService.requestPurchase(product: product)
            .asObservable()
            .flatMap { [weak self] result -> Observable<Mutation> in
                guard let self = self else { return .empty() }
                guard let result else {
                    return .just(.purchaseFailed(StoreError.failedPurchase))
                }
                return .concat([
                    .just(.purchaseCompleted(result)),
                    retrievePencilTotalBalance()
                ])
            }
            .catch { error -> Observable<Mutation> in
                return .just(.purchaseFailed(error))
            }
    }
    
    func transform(mutation: Observable<Mutation>) -> Observable<Mutation> {
        let transactionMutation = dependency.inAppPurchaseService.completedPurchasePencilDTO
            .map { Mutation.purchaseCompleted($0) }
            .flatMap { _ in self.retrievePencilTotalBalance() }
        
        return Observable.merge(mutation, transactionMutation)
    }
}

struct AcquiredSectionModel: Hashable {
    let section: AcquiredPencilSection
    let acquiredPencils: [AcquiredPencilDTO]
}

enum AcquiredPencilSection: Hashable {
    case main
}

struct PurchasedSectionModel: Hashable {
    let section: PurchasedPencilSection
    let purchasedPencils: [PurchasedPencilDTO]
}

enum PurchasedPencilSection: Hashable {
    case main
}

struct UsedSectionModel: Hashable {
    let section: UsedPencilSection
    let usedPencils: [UsedPencilDTO]
}

enum UsedPencilSection: Hashable {
    case main
}
