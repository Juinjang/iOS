import Foundation
import Model

// MARK: - Mock Home Data

public enum MockHomeData {

    public static let posts: [Post] = [
        Post(
            id: "1",
            title: "첫 번째 포스트",
            content: "테스트 내용입니다",
            authorId: "user_1",
            createdAt: Date()
        ),
        Post(
            id: "2",
            title: "두 번째 포스트",
            content: "또 다른 테스트 내용입니다",
            authorId: "user_2",
            createdAt: Date()
        )
    ]
}
