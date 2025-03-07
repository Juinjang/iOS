//
//  ProfileDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct ProfileDto {
    let nickname: String
    let email: String
    let provider: String
}

struct RefreshDto: Codable {
    let accessToken: String
    let refreshToken: String
    let email: String
}

struct EditProfileImageDto: Codable {
    let nickname: String
    let email: String
    let provider: String
    let image: String
}
