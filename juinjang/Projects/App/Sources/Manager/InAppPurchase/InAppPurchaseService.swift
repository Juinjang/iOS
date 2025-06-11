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
    
    var updateListenerTask: Task<Void, Never>? = nil
    let transactionCompleted = PublishSubject<VerifiyTransactionResponse>() // 외부에 알림용
    
    let buyPencilRepository: VerifyTransactionRepositoryProtocol
    
    init(buyPencilRepository: VerifyTransactionRepositoryProtocol) {
        self.buyPencilRepository = buyPencilRepository
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

    func purchase(_ product: Product) async throws -> VerifiyTransactionResponse? {
        let result = try await product.purchase()

        switch result {
        case .success(let verificationResult):
            do {
                let transaction = try checkVerified(verificationResult)
                
                // 서버 검증
                let verifyResult = try await buyPencilRepository.verifyTransaction(transaction: transaction)

                if verifyResult.isSuccess {
                    await transaction.finish()
                    return verifyResult
                } else {
                    await transaction.finish()
                    return nil
                }

            } catch {
//                storePendingTransaction(jws: verificationResult.jwsRepresentation)
                return nil
            }
        case .userCancelled, .pending: return nil
        default: return nil
        }
    }
    
    func listenForTransactions() -> Task<Void, Never> {
        Task.detached { [weak self] in
            guard let self else { return }

            for await result in Transaction.updates {
                do {
                    let transaction = try checkVerified(result)

                    do {
                        let verifyResult = try await buyPencilRepository.verifyTransaction(transaction: transaction)

                        if verifyResult.isSuccess {
                            transactionCompleted.onNext(verifyResult)
                            await transaction.finish()
                        } else {
                            await transaction.finish()
                            print("🚫 서버 검증 실패: \(transaction.id)")
                        }

                    } catch {
                        // 서버 통신 실패 → finish() 하지 않고 jws 저장
                        print("🌐 서버 요청 실패, 트랜잭션 저장: \(error)")
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
    
    func requestPurchase(product: Product) -> Single<VerifiyTransactionResponse?> {
        return Single.create { single in
            let task = Task.detached { [weak self] in
                guard let self else { return }
                do {
                    let verifyResult = try await purchase(product)
                    single(.success((verifyResult)))
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
}

public enum StoreError: Error {
    case failedRequestProducts
    case failedPurchase
    case failedVerification
}
