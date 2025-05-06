//
//  ShareWriteTimeCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

final class ShareWriteTimeCellItem: BaseCellItem, ShareWriteSectionProvidable {
    var isDoneEdit: Bool
    var periodModel: ImjangPeriod
    var sectionType: ShareWriteSection { .time }
    
    init(id: String,
         isDoneEdit: Bool,
         periodModel: ImjangPeriod) {
        self.isDoneEdit = isDoneEdit
        self.periodModel = periodModel
        super.init(id: id)
    }
}
