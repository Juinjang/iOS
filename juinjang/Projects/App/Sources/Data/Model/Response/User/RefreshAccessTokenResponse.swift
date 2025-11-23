//
//  RefreshAccessTokenResponse.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

struct RefreshAccessTokenResponse: Codable, DomainMappable {
    let accessToken: String
    let refreshToken: String
    let email: String
    
    func toDomain() -> RefreshAuthToken {
        return RefreshAuthToken(
            accessToken: accessToken,
            refreshToken: refreshToken,
            email: email
        )
    }
}
