//
//  ShareWritePhotoCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 5/4/25.
//

final class ShareWritePhotoCellItem: BaseCellItem, ShareWriteSectionProvidable {
    var sectionType: ShareWriteSection { .photo }
    var isPublic: Bool
    
    init(id: String,
         isPublic: Bool) {
        self.isPublic = isPublic
        super.init(id: id)
    }
}
