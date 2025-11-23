//
//  ToSItem.swift
//  juinjang
//
//  Created by 임수진 on 1/30/24.
//

import Foundation
import UIKit
import Then

struct ToSItem {
    var content: String
    var tag: Int
    
    func isRequired() -> Bool {
        let regex = try! NSRegularExpression(pattern: "(\\필수\\)", options: [])
        return regex.firstMatch(in: content, options: [], range: NSRange(location: 0, length: content.count)) != nil
    }
}

var termsOfService: [ToSItem] = [
    ToSItem(content: "(필수) 주인장 이용약관", tag: 0),
    ToSItem(content: "(필수) 개인정보 수집 및 이용 동의", tag: 1),
    ToSItem(content: "(선택) 마케팅 활용 동의", tag: 2)
]
