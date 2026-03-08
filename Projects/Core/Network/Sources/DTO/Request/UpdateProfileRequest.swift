//
//  UpdateProfileRequest.swift
//  Network
//
//  Created by 조유진 on 3/8/26.
//

public struct UpdateProfileRequest: Encodable {
    public let name: String
    public let profileImageURL: String?

    public init(name: String, profileImageURL: String? = nil) {
        self.name = name
        self.profileImageURL = profileImageURL
    }
}
