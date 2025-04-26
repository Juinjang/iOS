//
//  ImjangShareSelectCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

final class ImjangShareSelectCellItem: BaseCellItem, ImjangShareSelectSectionProvidable {
    let model: ImjangShareSelectModel
    var sectionType: ImjangShareSelectSection { .select }

    init(id: String,
         model: ImjangShareSelectModel) {
        self.model = model
        super.init(id: id)
    }
}
