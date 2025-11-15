import Foundation

public struct Login {
    let accessToken: String
    let refreshToken: String
    let email: String
    let agreeVersion: String
    
    public init(accessToken: String,
                refreshToken: String,
                email: String,
                agreeVersion: String) {
        self.accessToken = accessToken
        self.refreshToken = refreshToken
        self.email = email
        self.agreeVersion = agreeVersion
    }
}
