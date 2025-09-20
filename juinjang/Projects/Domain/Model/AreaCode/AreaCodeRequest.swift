//
//  AreaCodeRequest.swift
//  juinjang
//
//  Created by 조유진 on 7/5/25.
//

import Foundation

public struct AreaCodeRequest {
    let admCode: String?
    let format: String
    let numOfRows: Int?
    let pageNo: Int?
    var key: String
    
    init(admCode: String? = nil,
         format: String = "json",
         numOfRows: Int? = 1000,
         pageNo: Int = 1) {
        self.admCode = admCode
        self.format = format
        self.numOfRows = numOfRows
        self.pageNo = pageNo
        guard let admKey = Bundle.main.infoDictionary?["ADM_KEY"] as? String else {
            fatalError("ADM_KEY not found in Info.plist")
        }
        self.key = admKey
    }
}
