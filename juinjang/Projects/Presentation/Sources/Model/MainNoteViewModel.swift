//
//  MainNoteViewModel.swift
//  Scenes
//
//  Created by KimDongWoo on 11/11/25.
//

import DomainModel

struct MainNoteViewModel {
    let limjangId: Int
    let priceType: Int
    let image: String?
    let nickname: String
    let price: String
    let totalAverage: String?    // 체크리스트 생선 전일 경우 값은 nil
    let address: String?
    
    init(_ model: MainNote) {
        self.limjangId = model.limjangId
        self.priceType = model.priceType
        self.image = model.image
        self.nickname = model.nickname
        self.price = model.price
        self.totalAverage = model.totalAverage
        self.address = model.address
    }
}
