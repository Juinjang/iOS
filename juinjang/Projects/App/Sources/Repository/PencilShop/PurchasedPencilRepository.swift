//
//  PurchasedPencilRepository.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import RxSwift
import Foundation

protocol PurchasedPencilRepositoryProtocol {
    func fetchPurchasedPencilList() -> Observable<[PurchasedPencilModel]>
}

final class MockPurchasedPencilRepository: PurchasedPencilRepositoryProtocol {
    func fetchPurchasedPencilList() -> RxSwift.Observable<[PurchasedPencilModel]> {
        return .just(.mock)
    }
}

extension [PurchasedPencilModel] {
    static let mock: [PurchasedPencilModel] = [
        PurchasedPencilModel(
            purchasedPencilId: 1,
            purchaseQuantity: 10,
            remainQuantity: 20,
            title: "연필 10개 구매",
            price: 1200,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        PurchasedPencilModel(
            purchasedPencilId: 2,
            purchaseQuantity: 10,
            remainQuantity: 20,
            title: "연필 14개 구매",
            price: 1600,
            createdAt: "2025-03-06T15:30:45.123456"
        )
    ]
}

struct PurchasedPencilModel: Hashable {
    let id = UUID()
    let purchasedPencilId: Int
    let purchaseQuantity: Int
    let remainQuantity: Int
    let title: String
    let price: Int
    let createdAt: String
}
