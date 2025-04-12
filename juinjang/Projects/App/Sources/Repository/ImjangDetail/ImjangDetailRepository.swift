//
//  ImjangDetailRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/11/25.
//

import RxSwift

final class ImjangDetailRepository: ImjangDetailRepositoryProtocol {
    func fetchInfo() -> Observable<ImjangDetailInfoModel> {
        return Observable.just(infoMockModel)
            .delay(.milliseconds(700), scheduler: MainScheduler.instance)
    }
    
    func fetchReport() -> Observable<ImjangDetailReportModel> {
        return Observable.just(reportMockModel)
            .delay(.milliseconds(700), scheduler: MainScheduler.instance)
    }
    
    func fetchCheckList() -> Observable<ImjangDetailCheckListModel> {
        return Observable.just(checkListMockModel)
            .delay(.milliseconds(700), scheduler: MainScheduler.instance)
    }
    
    func fetchReview() -> Observable<ImjangDetailReviewModel> {
        return Observable.just(reviewMockModel)
            .delay(.milliseconds(700), scheduler: MainScheduler.instance)
    }
    
    private let infoMockModel: ImjangDetailInfoModel = {
        return .init(
            isBuyer: false,
            requiredPencils: 3,
            imageCount: 1,
            checkedCount: 32,
            reviewLength: 450,
            bulidingName: "판교푸르지오월드마크",
            propertyType: "APARTMENT",
            buyerCount: 10,
            images: ["",""],
            address: "서울시 동작구 노들로2길 7 (노량진드림 스퀘어 복합빌딩) A1620호",
            addressShort: "서울시 동작구",
            priceType: "PULL_RENT",
            price: "850000000",
            isLiked: false,
            likedCount: 332,
            period: "23년 12월 초반 임장",
            updatedAt: nil,
            viewCount: 69,
            floor: "12",
            pyung: "28",
            owerProfileUrl: "이미지",
            owerNickname: "닉네임",
            ownerProfileBio: "안녕하세요."
        )
    }()
    
    private let reportMockModel: ImjangDetailReportModel = {
        return .init(
            indoorKeyword: "상당히 쾌적한",
            publicSpaceKeyword: "훌륭한",
            locationConditionsKeyword: "좋은 편안",
            indoorRate: 4.5,
            publicSpaceRate: 4.5,
            locationConditionsRate: 4.5,
            totalRate: 4.5
        )
    }()
    
    private let checkListMockModel: ImjangDetailCheckListModel = {
        return .init(
            answerId: 1,
            questionId: 3,
            category: "LOCATION_CONDITION",
            limjangId: 1,
            answer: "4",
            answerType: "SCORE"
        )
    }()
    
    private let reviewMockModel: ImjangDetailReviewModel = {
        return .init(
            rate: 3.5,
            review: "사아아ㅏ아아아아아아랑해요~~~------"
        )
    }()
}
