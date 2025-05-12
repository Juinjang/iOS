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
    
    func fetchCheckList() -> Observable<[ImjangDetailCheckListModel]> {
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
            imageCount: 3,
            checkedCount: 32,
            reviewLength: 450,
            bulidingName: "판교푸르지오월드마크",
            propertyType: "APARTMENT",
            buyerCount: 10,
            images: ["https://ifh.cc/g/XLbxpj.jpg", "https://ifh.cc/g/XLbxpj.jpg", "https://ifh.cc/g/XLbxpj.jpg"], // "https://ifh.cc/g/XLbxpj.jpg"
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
            ownerProfileBio: "안녕하세요.",
            isOneRoom: true
        )
    }()
    
    private let reportMockModel: ImjangDetailReportModel = {
        return .init(
            indoorKeyword: "상당히 쾌적한",
            publicSpaceKeyword: "훌륭한",
            locationConditionsKeyword: "좋은 편안",
            indoorRate: 2.5,
            publicSpaceRate: 3.3,
            locationConditionsRate: 2.3,
            totalRate: 4.5
        )
    }()
    
    private let checkListMockModel: [ImjangDetailCheckListModel] = {
        return [
            .init(answerId: 1,
                  questionId: 3,
                  category: "LOCATION_CONDITION",
                  limjangId: 1,
                  answer: "4",
                  answerType: "SCORE"),
            .init(answerId: 2,
                  questionId: 4,
                  category: "LOCATION_CONDITION",
                  limjangId: 1,
                  answer: "수인분당",
                  answerType: "DROPDOWN"),
            .init(answerId: 3,
                  questionId: 20,
                  category: "LOCATION_CONDITION",
                  limjangId: 1,
                  answer: "2023년",
                  answerType: "DROPDOWN"),
            .init(answerId: 2,
                  questionId: 4,
                  category: "PUBLIC_SPACE",
                  limjangId: 1,
                  answer: "수인분당",
                  answerType: "DROPDOWN"),
            .init(answerId: 3,
                  questionId: 20,
                  category: "PUBLIC_SPACE",
                  limjangId: 1,
                  answer: "2023년",
                  answerType: "DROPDOWN"),
            .init(answerId: 2,
                  questionId: 4,
                  category: "INDOOR",
                  limjangId: 1,
                  answer: "수인분당",
                  answerType: "DROPDOWN"),
            .init(answerId: 3,
                  questionId: 20,
                  category: "INDOOR",
                  limjangId: 1,
                  answer: "2023년",
                  answerType: "DROPDOWN")
            
        ]
    }()
    
    private let reviewMockModel: ImjangDetailReviewModel = {
        return .init(
            rate: 3.5,
            review: "예시 후기내용 국회의원과 정부는 법률안을 제출할 수 있다. 모든 국민은 통신의 비밀을 침해받지 아니한다. \n국민경제자문회의의 조직·직무범위 기타 필요한 사항은 법률로 정한다."
        )
    }()
}
