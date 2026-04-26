public struct UpdateIntroductionRequest: Encodable, Sendable {
    public let introduction: String

    public init(introduction: String) {
        self.introduction = introduction
    }
}
