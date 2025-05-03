//
//  ObtainedPencilRepository.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import RxSwift
import Foundation

protocol ObtainedPencilRepositoryProtocol {
    func fetchObtainedPencilList() -> Observable<[ObtainedPencilModel]>
}

final class MockObtainedPencilRepository: ObtainedPencilRepositoryProtocol {
    func fetchObtainedPencilList() -> RxSwift.Observable<[ObtainedPencilModel]> {
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
