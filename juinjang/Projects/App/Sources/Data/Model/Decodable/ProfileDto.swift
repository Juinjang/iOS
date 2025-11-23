//
//  ProfileDto.swift
//  juinjang
//
//  Created by 조유진 on 2/9/24.
//

import Foundation

struct EditProfileImageDto: Codable {
    let nickname: String
    let email: String
    let provider: String
    let image: String
}
