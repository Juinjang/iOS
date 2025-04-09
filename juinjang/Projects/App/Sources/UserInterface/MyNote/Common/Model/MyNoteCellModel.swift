//
//  MyNoteCellModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/26/25.
//

import RxDataSources

struct MyNoteCellModel {
    let sharedNoteId: Int
    let bulidingName: String
    let imageUrl: String
    let isPurchase: Bool
    var isLike: Bool
    let rate: Double
    let type: String
    let price: String
    let pyong: Int
    let floor: String
    let address: String
    let onwerImageUrl: String
    let onwerNickname: String
    let monthAge: Int
    let viewCount: Int
    var isStopShare: Bool = false
    var isSelected: Bool = false
    
    init(model: MyNoteModel) {
        sharedNoteId = model.sharedNoteId
        bulidingName = model.bulidingName
        imageUrl = model.imageUrl
        isPurchase = model.isPurchase
        isLike = model.isLike
        rate = model.rate
        type = model.type
        price = model.price
        pyong = model.pyong
        floor = model.floor
        address = model.address
        onwerImageUrl = model.onwerImageUrl
        onwerNickname = model.onwerNickname
        monthAge = model.monthAge
        viewCount = model.viewCount
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
        lhs.bulidingName == rhs.bulidingName &&
        lhs.imageUrl == rhs.imageUrl &&
        lhs.isPurchase == rhs.isPurchase &&
        lhs.isLike == rhs.isLike &&
        lhs.rate == rhs.rate &&
        lhs.type == rhs.type &&
        lhs.price == rhs.price &&
        lhs.pyong == rhs.pyong &&
        lhs.floor == rhs.floor &&
        lhs.address == rhs.address &&
        lhs.onwerImageUrl == rhs.onwerImageUrl &&
        lhs.onwerNickname == rhs.onwerNickname &&
        lhs.monthAge == rhs.monthAge &&
        lhs.viewCount == rhs.viewCount
    }
}
