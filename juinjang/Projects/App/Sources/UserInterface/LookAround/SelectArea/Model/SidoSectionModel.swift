//
//  SidoSectionModel.swift
//  juinjang
//
//  Created by 조유진 on 7/5/25.
//

struct SidoSectionModel: Hashable {
    let section: SelectAreaSection
    let sidoItemList: [SidoCellItem]
    var selectedIndex: Int = 0
}
