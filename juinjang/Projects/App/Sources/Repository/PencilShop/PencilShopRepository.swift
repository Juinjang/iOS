//
//  PencilShopRepository.swift
//  juinjang
//
//  Created by 조유진 on 5/12/25.
//

import RxSwift
import Foundation
import StoreKit

protocol PencilShopRepositoryProtocol {
    func fetchObtainedPencilList() -> RxSwift.Observable<[ObtainedPencilModel]>
    func fetchPurchasedPencilList() -> RxSwift.Observable<[PurchasedPencilModel]>
    func fetchUsedPencilList() -> RxSwift.Observable<[UsedPencilModel]> 
}

final class PencilShopRepository: PencilShopRepositoryProtocol {
    func fetchObtainedPencilList() -> RxSwift.Observable<[ObtainedPencilModel]> {
        return .just(.mock)
    }
    
    func fetchPurchasedPencilList() -> RxSwift.Observable<[PurchasedPencilModel]> {
        return .just(.mock)
    }
    
    func fetchUsedPencilList() -> RxSwift.Observable<[UsedPencilModel]> {
        return .just(.mock)
    }
}

extension [ObtainedPencilModel] {
    static let mock: [ObtainedPencilModel] = [
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        ),
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        ),
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        ),
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        ),
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        ),
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        ),
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        ),
        ObtainedPencilModel(
            acquiredPencilId: 1,
            content: "[일이삼사오육칠팔구십...]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: true,
            type: "공유",
            sharedNoteId: 1
        ),
        ObtainedPencilModel(
            acquiredPencilId: 2,
            content: "[판교동아파트..]조회수 100 달성",
            createdAt: "2025-03-11T15:30:45.123456",
            acquiredQuantity: 3,
            isRead: false,
            type: "공유",
            sharedNoteId: 2
        )
    ]
}

struct ObtainedPencilModel: Hashable {
    let id = UUID()
    let acquiredPencilId: Int
    let content: String
    let createdAt: String
    let acquiredQuantity: Int
    let isRead: Bool
    let type: String
    let sharedNoteId: Int
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


extension [UsedPencilModel] {
    static let mock: [UsedPencilModel] = [
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 1,
            useQuantity: 3,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "판교로 134길",
            sharedNoteId: 50,
            createdAt: "2025-03-11T15:30:45.123456"
        ),
        UsedPencilModel(
            usedPencilId: 2,
            useQuantity: 6,
            type: "OWNED",
            remainQuantity: 20,
            buildingName: "신림로 125",
            sharedNoteId: 24,
            createdAt: "2025-03-06T15:30:45.123456"
        ),
    ]
}

struct UsedPencilModel: Hashable {
    let id = UUID()
    let usedPencilId: Int
    let useQuantity: Int
    let type: String
    let remainQuantity: Int
    let buildingName: String
    let sharedNoteId: Int
    let createdAt: String
}
