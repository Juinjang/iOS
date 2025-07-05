//
//  DongSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 7/5/25.
//

struct DongSectionModel: Hashable {
    let section: SelectAreaSection
    let sigunguItemList: [DongCellItem]
    let selectedId: [Int] = []
}
