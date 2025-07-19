//
//  PostCodeResponseModel.swift
//  juinjang
//
//  Created by KimDongWoo on 5/26/25.
//

struct PostCodeResponseModel: Codable {
    let bcode: String
    let address: String
    let sido: String
    let sigungu: String
    var bname1: String?
    let bname2: String
    
    enum CodingKeys: String, CodingKey {
        case bcode
        case address = "roadAddress"
        case sido
        case sigungu
        case bname1
        case bname2
    }
}
