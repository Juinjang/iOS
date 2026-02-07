//
//  MyNoteCellModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/26/25.
//

import RxDataSources

struct MyNoteCellModel {
    let sharedNoteId: Int
    let buildingName: String
    let imageUrl: String?
    let isPurchase: Bool
    var isLike: Bool
    let rate: Double
    let price: String
    let pyong: Int?
    let floor: String?
    let address: String
    let ownerImageUrl: String?
    let ownerNickname: String
    let timeAge: String
    let viewCount: Int
    var isStopShare: Bool = false
    var isSelected: Bool = false
    var propertyType: String
    let priceType: String
    let monthlyRent: String?
    
    init(model: MyNoteModel) {
        sharedNoteId = model.sharedNoteId
        buildingName = model.buildingName
        imageUrl = model.imageUrl
        isPurchase = model.isPurchase
        isLike = model.isLiked
        rate = model.rate?.to1f ?? 0.0
        price = model.price
        pyong = model.pyong
        floor = model.floor
        address = model.address
        ownerImageUrl = model.ownerImageUrl
        ownerNickname = model.ownerNickname
        timeAge = model.timeAge
        viewCount = model.viewCount
        propertyType = model.propertyType
        priceType = model.priceType
        monthlyRent = model.monthlyRent
    }
}

extension MyNoteCellModel: IdentifiableType {
    var identity: Int {
        return sharedNoteId
    }
    
    mutating func setupStopShare() {
        self.isStopShare = true
    }
}

extension MyNoteCellModel: Equatable {
    static func == (lhs: MyNoteCellModel, rhs: MyNoteCellModel) -> Bool {
        return lhs.sharedNoteId == rhs.sharedNoteId &&
        lhs.buildingName == rhs.buildingName &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.isPurchase == rhs.isPurchase &&
        lhs.isLike == rhs.isLike &&
        lhs.rate == rhs.rate &&
        lhs.price == rhs.price &&
        lhs.pyong == rhs.pyong &&
        lhs.floor == rhs.floor &&
        lhs.address == rhs.address &&
        lhs.ownerImageUrl == rhs.ownerImageUrl &&
        lhs.ownerNickname == rhs.ownerNickname &&
        lhs.timeAge == rhs.timeAge &&
        lhs.viewCount == rhs.viewCount
    }
}
