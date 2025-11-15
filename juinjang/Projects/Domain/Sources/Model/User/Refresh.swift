import Foundation

public struct Refresh {
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
