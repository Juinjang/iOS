//
//  ImjangDetailInfoCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/12/25.
//

final class ImjangDetailInfoCellItem: BaseCellItem, ImjangDetailSectionProvidable {
    let model: ImjangDetailInfoModel
    var sectionType: ImjangDetailSection { .info }

    init(id: String,
         model: ImjangDetailInfoModel) {
        self.model = model
        super.init(id: id)
    }
}
