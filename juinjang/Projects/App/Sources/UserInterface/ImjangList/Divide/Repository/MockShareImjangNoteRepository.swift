//
//  MockShareImjangNoteRepository.swift
//  juinjang
//
//  Created by 강동영 on 3/7/25.
//

import Foundation
import RxSwift

final class MockShareImjangNoteRepository: ShareImjangNoteRepository {
    private var currentOffset: Int = 0
    func fetchNotes(offset: Int = 0, limit: Int = 20) -> Observable<[ListDto]>{
        currentOffset = offset
        return .just(.mock)
    }
}

extension [ListDto] {
    static let mock: [ListDto] = [
        ListDto(nickname: "채드"),
        ListDto(nickname: "채드1"),
        ListDto(nickname: "채드2"),
        ListDto(nickname: "채드3"),
        ListDto(nickname: "채드4"),
        ListDto(nickname: "채드5"),
        ListDto(nickname: "채드6"),
        ListDto(nickname: "채드7"),
    ]
}
