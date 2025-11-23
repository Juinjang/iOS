//
//  Profile.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct Profile {
    public let nickname: String
    let introduction: String?
    let email: String
    let image: String?
    let provider: String
    
    public init(nickname: String,
                introduction: String?,
                email: String,
                image: String?,
                provider: String) {
        self.nickname = nickname
        self.introduction = introduction
        self.email = email
        self.image = image
        self.provider = provider
    }
}
