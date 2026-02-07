//
//  ImjangDetailReviewCellItem.swift
//  juinjang
//
//  Created by KimDongWoo on 4/12/25.
//

final class ImjangDetailReviewCellItem: BaseCellItem, ImjangDetailSectionProvidable {
    let model: ImjangDetailReviewModel
    var sectionType: ImjangDetailSection { .review }

    init(id: String,
         model: ImjangDetailReviewModel) {
        self.model = model
        super.init(id: id)
    }
}
