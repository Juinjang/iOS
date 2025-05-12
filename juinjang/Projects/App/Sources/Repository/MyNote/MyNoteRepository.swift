//
//  MyNoteRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 3/16/25.
//

import RxSwift

enum MyNoteCategoryType: Int, CaseIterable {
    case share = 0
    case own = 1
    case like = 2
}

extension MyNoteCategoryType {
    var toText: String {
        switch self {
        case .share:
            return "공유된 노트"
        case .own:
            return "소장한 노트"
        case .like:
            return "좋아한 노트"
        }
    }
}

final class MyNoteRepository: MyNoteRepositoryProtocol {
    private var currentOffset: Int = 0
    
    func fetchMyNotes(category: MyNoteCategoryType,
                      offset: Int,
                      limit: Int) -> Observable<[MyNoteModel]> {
        currentOffset = offset
        
        switch category {
        case .share:
            return .just(.shareMock)
        case .own:
            return .just(.ownMock)
        case .like:
            return .just(.likeMock)
        }
    }
    
    func fetchMyNotes(keyword: String) -> Observable<[MyNoteModel]> {
        return .just(.shareMock)
    }
}

extension [MyNoteModel] {
    static let shareMock: [MyNoteModel] = [
        .init(
            sharedNoteId: 0,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: true,
            isLike: true,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "떙땡땡땡",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"
        ),
        .init(
            sharedNoteId: 1,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: true,
            isLike: true,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "떙땡",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"
        ),
        .init(
            sharedNoteId: 2,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: true,
            isLike: false,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "asdd",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"
        ),
        .init(
            sharedNoteId: 3,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: true,
            isLike: false,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "as",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"

        ),
        .init(
            sharedNoteId: 4,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: true,
            isLike: false,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "떙땡",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"
        ),
        .init(
            sharedNoteId: 5,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: true,
            isLike: true,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "떙땡",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"
        )
    ]
    
    static let ownMock: [MyNoteModel] = [
    ]
    
    static let likeMock: [MyNoteModel] = [
        .init(
            sharedNoteId: 0,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: false,
            isLike: false,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "떙땡",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"
        ),
        .init(
            sharedNoteId: 1,
            bulidingName: "판교푸르지오월드마크",
            imageUrl: "",
            isPurchase: false,
            isLike: false,
            rate: 4.6,
            type: "매매",
            price: "7억 3,000",
            pyong: 28,
            floor: "3층",
            address: "성남시 분당구",
            onwerImageUrl: "",
            onwerNickname: "떙땡",
            monthAge: 5,
            viewCount: 1000,
            propertyType: "APARTMENT"
        )
    ]
}
