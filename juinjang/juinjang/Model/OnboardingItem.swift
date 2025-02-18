//
//  OnboardingItem.swift
//  juinjang
//
//  Created by 조유진 on 8/21/24.
//

import Foundation

struct OnboardingItem {
    let title: String
    let keyword: String
    let jsonURLString: String
    
    init(title: String, keyword: String, jsonURLString: String) {
        self.title = title
        self.keyword = keyword
        self.jsonURLString = jsonURLString
    }
}
