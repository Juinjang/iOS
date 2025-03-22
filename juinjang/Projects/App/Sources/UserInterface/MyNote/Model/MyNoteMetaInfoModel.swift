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
    
    init(_ model: MyNoteModel) {
        self.imageUrl = model.imageUrl
        self.nickname = model.onwerNickname
        self.createDate = model.monthAge.monthAgoString
        self.viewCount = model.viewCount.viewCountString
    }
}
