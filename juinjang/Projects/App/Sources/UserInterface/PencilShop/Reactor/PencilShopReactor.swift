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
                print("@@@", isTotalReadDTO)
                return .just(.setIsTotalRead(isTotalReadDTO.isTotalRead))
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
                    return .just(.setAcquiredList(obtainedList))
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
        
        return dependency.pencilShopRepository.readAcquiredPencil(parameter: ReadAcquiredPencilRequestDTO(acquiredPencilId: selectedAquiredPencil.acquiredPencilId))
            .asObservable()
            .flatMap { readAcquiredPencilDTO -> Observable<Mutation> in
                print("얻은 연필 읽음 처리 완료: \(readAcquiredPencilDTO.isMarked), isTotalRead: \(readAcquiredPencilDTO.isTotalRead)")
                return .concat([
                    .just(.setAcquiredList(acquiredPencils)),
                    .just(.setIsTotalRead(readAcquiredPencilDTO.isTotalRead))
                ])
            }
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

struct AcquiredSectionModel {
    let section: AcquiredPencilSection
    let acquiredPencils: [AcquiredPencilDTO]
}

enum AcquiredPencilSection: Hashable {
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
