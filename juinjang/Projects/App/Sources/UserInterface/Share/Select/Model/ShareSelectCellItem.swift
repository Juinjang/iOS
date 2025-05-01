//
//  ImjangShareSelectCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

final class ShareSelectCellItem: BaseCellItem, ShareSelectSectionProvidable {
    let model: ShareSelectModel
    var sectionType: ShareSelectSection { .select }
    var isSelected: Bool = false

    init(id: String,
         model: ShareSelectModel) {
        self.model = model
        super.init(id: id)
    }
}
