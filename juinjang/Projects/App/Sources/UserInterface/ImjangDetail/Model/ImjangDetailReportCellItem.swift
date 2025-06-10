//
//  ImjangDetailReportCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/12/25.
//

final class ImjangDetailReportCellItem: BaseCellItem, ImjangDetailSectionProvidable {
    let model: ImjangDetailReportModel
    var sectionType: ImjangDetailSection { .report }

    init(id: String,
         model: ImjangDetailReportModel) {
        self.model = model
        super.init(id: id)
    }
}
