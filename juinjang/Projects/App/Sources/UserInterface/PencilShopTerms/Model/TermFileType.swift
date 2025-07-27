//
//  TermFileType.swift
//  juinjang
//
//  Created by KimDongWoo on 7/24/25.
//

enum TermFileType: String {
    case pencilShop = "PencilShopTerms"
    
    var filename: String {
        return self.rawValue
    }
    
    var fileExtension: String {
        return "json"
    }
}
