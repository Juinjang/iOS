//
//  UsedPencilRepository.swift
//  juinjang
//
//  Created by 조유진 on 4/16/25.
//

import RxSwift
import Foundation

protocol UsedPencilRepositoryProtocol {
    func fetchUsedPencilList() -> Observable<[UsedPencilModel]>
}

final class MockUsedPencilRepository: UsedPencilRepositoryProtocol {
    func fetchUsedPencilList() -> RxSwift.Observable<[UsedPencilModel]> {
        return .just(.mock)
    }
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
