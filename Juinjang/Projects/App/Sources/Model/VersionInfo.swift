//
//  VersionInfo.swift
//  juinjang
//
//  Created by 임수진 on 2/12/24.
//

import Foundation

struct VersionInfo {
    var version: Int // 0: 임장용, 1: 원룸용
    var editCriteria: Int // 0: 실거래가 수정정보 제공, 1: 매매-전세-월세 수정정보 제공
    
    init(version: Int, editCriteria: Int) {
        self.version = version
        self.editCriteria = editCriteria
    }
}
