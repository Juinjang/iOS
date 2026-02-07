//
//  LookAroundRepository.swift
//  juinjang
//
//  Created by 조유진 on 3/30/25.
//

import RxSwift

protocol LookAroundRepositoryProtocol {
    func fetchLookAroundImjang(cursor: Int,
                               limit: Int,
                               keyword: String) -> Observable<LookAroundImjangResult>
}

extension LookAroundRepositoryProtocol {
    func fetchLookAroundImjang(cursor: Int = 0,
                               limit: Int = 15,
                               keyword: String = "건물") -> Observable<LookAroundImjangResult> {
        fetchLookAroundImjang(cursor: cursor, limit: limit, keyword: keyword)
    }
}

final class MockLookAroundRepository: LookAroundRepositoryProtocol {
    private var currentCursor: Int = 0
    func fetchLookAroundImjang(cursor: Int = 0, limit: Int = 15, keyword: String = "건물") -> RxSwift.Observable<LookAroundImjangResult> {
        currentCursor = cursor
        return .just(.mock)
    }
}

extension LookAroundImjangResult {
    static let mock: LookAroundImjangResult =
    LookAroundImjangResult(
        totalResults: 5,
        notes: [
            LookAroundImjangNote(
                sharedNoteId: 101,
                buildingName: "판교푸르지오월드마크",
                propertyType: "APARTMENT",
                imageUrl: "https://images.homify.com/v1439373978/p/photo/image/816898/_MG_3482.jpg",
                isPurchase: true,
                isLiked: true,
                rate: 4.6,
                type: "매매",
                price: "600000000",
                pyong: 28,
                floor: "3",
                address: "성남시 분당구",
                ownerImageUrl: "https://i.pinimg.com/736x/4a/ab/42/4aab42c1a269ec427e9165ae89b195c9.jpg",
                ownerNickname: "망곰",
                monthAge: 5,
                viewCount: 934
            ),
            LookAroundImjangNote(
                sharedNoteId: 102,
                buildingName: "구로 오피스텔",
                propertyType: "OFFICE_TEL",
                imageUrl: "https://cdn.woodkorea.co.kr/news/photo/202307/74235_84692_1423.jpg",
                isPurchase: false,
                isLiked: false,
                rate: 3.7,
                type: "전세",
                price: "320000000",
                pyong: 28,
                floor: "3",
                address: "서울시 구로구",
                ownerImageUrl: "https://example.com/image.jpg",
                ownerNickname: "땡땡",
                monthAge: 5,
                viewCount: 10000
            ),
            LookAroundImjangNote(
                sharedNoteId: 103,
                buildingName: "동작구 빌라",
                propertyType: "VILLA",
                imageUrl: "https://image.chosun.com/sitedata/image/201810/29/2018102902845_0.jpg",
                isPurchase: true,
                isLiked: true,
                rate: 5.0,
                type: "매매",
                price: "432300000",
                pyong: 28,
                floor: "3",
                address: "서울시 동작구",
                ownerImageUrl: "https://i.pinimg.com/736x/38/17/a4/3817a4e448392740848bdbbc083537cb.jpg",
                ownerNickname: "팽쿠",
                monthAge: 7,
                viewCount: 24
            ),
            LookAroundImjangNote(
                sharedNoteId: 104,
                buildingName: "반지하",
                propertyType: "DETACHED_HOUSE",
                imageUrl: "https://t1.daumcdn.net/news/202112/03/hankooki/20211203043054197dkdk.jpg",
                isPurchase: false,
                isLiked: false,
                rate: 1.2,
                type: "매매",
                price: "300000000",
                pyong: 28,
                floor: "3",
                address: "서울시 중랑구",
                ownerImageUrl: "https://i.pinimg.com/736x/3e/b2/70/3eb27037b0f0e7c460a5df769cbf7605.jpg",
                ownerNickname: "햄터",
                monthAge: 1,
                viewCount: 15
            ),
            LookAroundImjangNote(
                sharedNoteId: 105,
                buildingName: "압구정현대8차아파트",
                propertyType: "APARTMENT",
                imageUrl: "https://example.com/image.jpg",
                isPurchase: true,
                isLiked: true,
                rate: 4.1,
                type: "매매",
                price: "721000000",
                pyong: 28,
                floor: "3",
                address: "서울시 강남구",
                ownerImageUrl: "https://example.com/image.jpg",
                ownerNickname: "춘봉",
                monthAge: 5,
                viewCount: 10000
            ),
            LookAroundImjangNote(
                sharedNoteId: 105,
                buildingName: "성북동 단독주택",
                propertyType: "DETACHED_HOUSE",
                imageUrl: "https://example.com/image.jpg",
                isPurchase: false,
                isLiked: true,
                rate: 2.3,
                type: "매매",
                price: "100000000",
                pyong: 129,
                floor: "3",
                address: "서울시 성북구",
                ownerImageUrl: "https://i.pinimg.com/736x/0b/0d/e7/0b0de708d7d78ea63f19ef95357ff154.jpg",
                ownerNickname: "곰곰이",
                monthAge: 2,
                viewCount: 341
            ),
            LookAroundImjangNote(
                sharedNoteId: 105,
                buildingName: "강남역 오피스텔",
                propertyType: "OFFICE_TEL",
                imageUrl: "https://example.com/image.jpg",
                isPurchase: true,
                isLiked: false,
                rate: 4.1,
                type: "매매",
                price: "3431000000",
                pyong: 28,
                floor: "3",
                address: "서울시 강남구",
                ownerImageUrl: "https://example.com/image.jpg",
                ownerNickname: "홍길동",
                monthAge: 11,
                viewCount: 10000
            )
        ]
    )
}
