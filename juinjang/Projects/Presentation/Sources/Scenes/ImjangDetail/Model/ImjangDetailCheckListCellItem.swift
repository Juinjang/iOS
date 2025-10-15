//
//  ImjangDetailCheckListCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/12/25.
//

final class ImjangDetailCheckListCellItem: BaseCellItem, ImjangDetailSectionProvidable {
    let model: ImjangDetailCheckListModel
    var sectionType: ImjangDetailSection { .checkList }

    init(id: String,
         model: ImjangDetailCheckListModel) {
        self.model = model
        super.init(id: id)
    }
}
