//
//  ShareWriteShareCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

final class ShareWriteShareCellItem: BaseCellItem, ShareWriteSectionProvidable {
    let model: ShareSelectModel
    var sectionType: ShareWriteSection { .share }
    
    init(id: String,
         model: ShareSelectModel) {
        self.model = model
        super.init(id: id)
    }
}
