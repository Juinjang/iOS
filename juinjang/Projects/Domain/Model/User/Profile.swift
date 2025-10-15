import Foundation

struct Profile {
    let nickname: String
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
