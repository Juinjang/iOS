//
//  InAppPurchaseService.swift
//  juinjang
//
//  Created by 조유진 on 4/28/25.
//

import Foundation
import StoreKit
import RxSwift


final class InAppPurchaseService {
    private let productIdList: [String: String]
    private var pencilProductList: [Product] = []
    
    private var disposeBag = DisposeBag()
    var updateListenerTask: Task<Void, Never>? = nil
    let completedPurchasePencilDTO = PublishSubject<PurchasePencilDTO?>() // 외부에 알림용
    
    let pencilShopRepository: PencilShopRepository
    
    init(pencilShopRepository: PencilShopRepository) {
        self.pencilShopRepository = pencilShopRepository
        self.productIdList = InAppPurchaseService.loadProductIdList()
        
        updateListenerTask = listenForTransactions()
        
        Task {
            try await requestProducts()
        }
    }
    
    static func loadProductIdList() -> [String: String] {
        guard let products = Bundle.main.object(forInfoDictionaryKey: "Products") as? [String: String] else { return [:] }
        return products
    }
    
    private func requestProducts() async throws -> [Product] {
        do {
            let storeProducts = try await Product.products(for: productIdList.keys)
            var newPencils: [Product] = []
            for product in storeProducts {
                switch product.type {
                case .consumable:
                    newPencils.append(product)
                default:
                    break
                }
            }
            
            pencilProductList = sortByName(newPencils)
            return pencilProductList
        } catch {
            print(error)
            throw StoreError.failedRequestProducts
        }
    }
        
    private func sortByName(_ products: [Product]) -> [Product] {
        products.sorted(by: { return $0.displayName < $1.displayName })
    }

    func purchase(_ product: Product,
                  completionHandler: @escaping (PurchasePencilDTO?) -> Void) async throws {
        let myToken = UUID()
        let result = try await product.purchase(options: [.appAccountToken(myToken)])

        switch result {
        case .success(let verificationResult):
            do {
                let transaction = try checkVerified(verificationResult)
                
                let purchasePencilRequest = PurchasePencilRequestDTO(
                    transactionId: "\(transaction.id)",
                    appAccountToken: transaction.appAccountToken?.uuidString ?? "",
                    pencilQuantity: product.displayName.pencilQuantity,
                    price: productPrice(productId: product.id),
                    productId: transaction.productID,
                    playTime: Int(PlayTimeTracker.shared.getPlayTime())
                )
                
                dump(purchasePencilRequest)
                
                // 서버 검증
                pencilShopRepository.purchasePencil(parameter: purchasePencilRequest)
                    .asObservable()
                    .subscribe(with: self) { owner, purchasePencilDTO in
                        completionHandler(purchasePencilDTO)
                    }
                    .disposed(by: disposeBag)

                await transaction.finish()
            } catch {
                completionHandler(nil)
            }
        case .userCancelled, .pending: completionHandler(nil)
        default: completionHandler(nil)
        }
    }
    
    func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            guard let self else { return }

            for await result in Transaction.updates {
                do {
                    let transaction = try checkVerified(result)

                    do {
                        let purchasePencilRequest = PurchasePencilRequestDTO(
                            transactionId: "\(transaction.id)",
                            appAccountToken: transaction.appAccountToken?.uuidString ?? "",
                            pencilQuantity: transaction.productID.pencilQuantity,
                            price: productPrice(productId: transaction.productID),
                            productId: transaction.productID,
                            playTime: Int(PlayTimeTracker.shared.getPlayTime())
                        )
                        
                        // 서버 검증
                        pencilShopRepository.purchasePencil(parameter: purchasePencilRequest)
                            .asObservable()
                            .subscribe(with: self) { owner, purchasePencilDTO in
                                owner.completedPurchasePencilDTO.onNext(purchasePencilDTO)
                            }
                            .disposed(by: disposeBag)
                        await transaction.finish()
                    }
                } catch {
                    print("🚫 트랜잭션 서명 검증 실패")
                    // VerificationResult가 .unverified인 경우는 대부분 버리는 것이 맞음
                }
            }
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
}

extension InAppPurchaseService {
    func requestProductList() -> Single<[Product]> {
        
        return Single.create { single in
            let task = Task { [weak self] in
                guard let self else {
                    return single(.failure(StoreError.failedRequestProducts))
                }
                do {
                    let products = try await requestProducts()
                    single(.success(products))
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    func requestPurchase(product: Product) -> Single<PurchasePencilDTO?> {
        return Single.create { single in
            let task = Task.detached { [weak self] in
                guard let self else { return }
                do {
                    try await purchase(product) { purchasePencilDTO in
                        single(.success((purchasePencilDTO)))
                    }
                } catch {
                    single(.failure(error))
                }
            }
            return Disposables.create {
                task.cancel()
            }
        }
    }
    
    private func storePendingTransaction(jws: String) {
        let pendingTransaction = PendingTransaction(jws: jws, createdAt: Date())
        PendingTransactionStore.shared.save(pendingTransaction)
    }
    
    private func productPrice(productId: String) -> Int {
        guard let infoDict = Bundle.main.infoDictionary,
              let products = infoDict["Products"] as? [String: String] else {
            return 0
        }
        return Int(products[productId] ?? "") ?? 0
    }
}

public enum StoreError: Error {
    case failedRequestProducts
    case failedPurchase
    case failedVerification
}
