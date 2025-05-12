//
//  ShareWriteNoticeCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

final class ShareWriteNoticeCellItem: BaseCellItem, ShareWriteSectionProvidable {
    let model: ShareSelectModel
    var sectionType: ShareWriteSection { .notice }
    
    init(id: String,
         model: ShareSelectModel) {
        self.model = model
        super.init(id: id)
    }
}
