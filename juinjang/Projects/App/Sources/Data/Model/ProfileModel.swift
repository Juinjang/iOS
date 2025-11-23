//
//  ProfileModel.swift
//  juinjang
//
//  Created by KimDongWoo on 5/18/25.
//

struct ProfileModel: Codable {
    let nickname: String
    let introduction: String?
    let email: String
    let image: String?
    let provider: String
}
