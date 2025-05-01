//
//  ShareRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import RxSwift

final class ShareRepository: ShareRepositoryProcotol {
    private var fetchCount = 0
    
    func fetchShareSelectNote() -> Observable<[ShareSelectModel]> {
        fetchCount += 1
        
        let result: [ShareSelectModel]
        
        if fetchCount >= 3 {
            result = []
        } else {
            result = createMockShareSelectModels()
        }
        
        return Observable.just(result)
            .delay(.milliseconds(700), scheduler: MainScheduler.instance)
    }
}

extension ShareRepository {
    private func createMockShareSelectModels() -> [ShareSelectModel] {
        return [
            .init(noteId: 1,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "VILLA",
                  priceType: "MARKET_PRICE",
                  name: "내집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 10,
                  floor: "10",
                  shortAddress: "강남구 신사동",
                  rewardPencil: 3),
            .init(noteId: 2,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: true,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 3,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 4,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 5,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 6,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 7,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 8,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 9,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3),
            .init(noteId: 10,
                  purposeType: "RESIDENTIAL_PURPOSE",
                  propertyType: "APARTMENT",
                  priceType: "MARKET_PRICE",
                  name: "판교집",
                  imageUrl: "",
                  isScraped: false,
                  rate: 4.5,
                  price: "2200000000",
                  monthlyRent: nil,
                  pyong: 45,
                  floor: "20",
                  shortAddress: "성남시 분당구",
                  rewardPencil: 3)
        ]
    }
}
