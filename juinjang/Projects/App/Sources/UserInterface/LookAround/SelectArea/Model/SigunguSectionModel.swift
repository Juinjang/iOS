//
//  SigunguSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 7/5/25.
//

struct SigunguSectionModel: Hashable {
    let section: SelectAreaSection
    let sigunguItemList: [SigunguCellItem]
    var selectedIndex: Int = 0
}
