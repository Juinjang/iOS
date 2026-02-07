//
//  MyNoteMetaInfoModel.swift
//  juinjang
//
//  Created by KimDongWoo on 3/21/25.
//

struct MyNoteMetaInfoModel {
    let imageUrl: String
    let nickname: String
    let createDate: String
    let viewCount: String
    
    init(_ model: MyNoteCellModel) {
        self.imageUrl = model.ownerImageUrl ?? ""
        self.nickname = model.ownerNickname
        self.createDate = model.timeAge
        self.viewCount = model.viewCount.viewCountString
    }
}
