//
//  RefreshAuthToken.swift
//  App
//
//  Created by 조유진 on 11/23/25.
//

import Foundation

public struct RefreshAuthToken {
    let accessToken: String
    let refreshToken: String
    let email: String
    
    public init(accessToken: String,
                refreshToken: String,
                email: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.email = email
    }
}
