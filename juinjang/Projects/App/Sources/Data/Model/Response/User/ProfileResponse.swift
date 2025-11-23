//
//  ProfileResponse.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

struct ProfileResponse: Codable, DomainMappable {
    let nickname: String
    let introduction: String?
    let email: String
    let image: String?
    let provider: String
    
    func toDomain() -> Profile {
        return Profile(
            nickname: nickname,
            introduction: introduction,
            email: email,
            image: image,
            provider: provider
        )
    }
}
