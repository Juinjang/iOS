//
//  DongSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 7/5/25.
//

struct DongSectionModel: Hashable {
    let section: SelectAreaSection
    var dongItemList: [DongCellItem]
    var selectedIndexs: Set<Int> = []
}
