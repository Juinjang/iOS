//
//  ShareWritePeriodCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

final class ShareWritePeriodCellItem: BaseCellItem, ShareWriteSectionProvidable {
    var isDoneEdit: Bool
    var periodModel: ImjangPeriod
    var sectionType: ShareWriteSection { .period }
    
    init(id: String,
         isDoneEdit: Bool,
         periodModel: ImjangPeriod) {
        self.isDoneEdit = isDoneEdit
        self.periodModel = periodModel
        super.init(id: id)
    }
}
