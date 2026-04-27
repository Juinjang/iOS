import Foundation

import Common
import Model

import ComposableArchitecture

// MARK: - UserClient Preview Mock
/// SwiftUI Preview에서 자동 사용되는 mock 데이터.
/// `picsum.photos`는 Preview 표준 placeholder 이미지 서비스 (seed 고정 시 동일 이미지 반환).

extension UserClient {
    public static let previewValue = UserClient(
        fetchMyProfile: {
            UserProfile(
                nickname: "땡땡",
                introduction: "안녕하세요, 주인장에서 만나요",
                email: "juinjang@daum.net",
                imageURL: "https://picsum.photos/seed/juinjang/200",
                provider: .kakao
            )
        },
        updateNickname: { _ in },
        updateIntroduction: { _ in },
        uploadProfileImage: { _ in
            "https://picsum.photos/seed/uploaded/200"
        },
        logout: { }
    )
}
