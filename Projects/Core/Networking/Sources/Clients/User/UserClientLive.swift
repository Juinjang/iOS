import Foundation

import Common
import Dependency
import Model

import Alamofire
import ComposableArchitecture

// MARK: - UserClient Live Implementation
/// Core/Dependency의 UserClient interface를 실제 네트워크 호출로 구현.
/// App 모듈에서 링크되어 런타임에 자동 주입됩니다.

extension UserClient: @retroactive DependencyKey {

    public static let liveValue: Self = {
        let client = NetworkClient()

        return UserClient(
            fetchMyProfile: {
                let response: ResultResponse<FetchProfileResponse> = try await client.request(
                    UserAPI.getMyProfile,
                    responseType: ResultResponse<FetchProfileResponse>.self
                )
                return try APIMapper.mapData(
                    response,
                    transform: { $0.toDomain() }
                )
            },

            updateNickname: { nickname in
                let response: VoidResponse = try await client.request(
                    UserAPI.patchNickname(.init(nickname: nickname)),
                    responseType: VoidResponse.self
                )
                try APIMapper.mapVoid(response)
            },

            updateIntroduction: { introduction in
                let response: VoidResponse = try await client.request(
                    UserAPI.patchIntroduction(.init(introduction: introduction)),
                    responseType: VoidResponse.self
                )
                try APIMapper.mapVoid(response)
            },

            uploadProfileImage: { jpegData in
                let multipart = MultipartData(parts: [
                    .init(
                        data: jpegData,
                        name: "multipartFile",
                        fileName: "image.jpg",
                        mimeType: "image/jpeg"
                    )
                ])
                let response: ResultResponse<EditProfileImageResponse> = try await client.upload(
                    UserAPI.patchProfileImage,
                    multipart: multipart,
                    responseType: ResultResponse<EditProfileImageResponse>.self
                )
                return try APIMapper.mapData(
                    response,
                    transform: { $0.image }
                )
            },

            logout: {
                let response: VoidResponse = try await client.request(
                    UserAPI.logout,
                    responseType: VoidResponse.self
                )
                try APIMapper.mapVoid(response)
            }
        )
    }()
}
