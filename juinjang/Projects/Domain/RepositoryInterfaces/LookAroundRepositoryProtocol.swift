//
//  LookAroundRepositoryProtocol.swift
//  Data
//
//  Created by KimDongWoo on 9/16/25.
//

public protocol LookAroundRepositoryProtocol {
    func fetchLookAroundImjang(cursor: Int,
                               limit: Int,
                               keyword: String) -> Observable<LookAroundImjangResult>
}

extension LookAroundRepositoryProtocol {
    func fetchLookAroundImjang(cursor: Int = 0,
                               limit: Int = 15,
                               keyword: String = "건물") -> Observable<LookAroundImjangResult> {
        fetchLookAroundImjang(cursor: cursor, limit: limit, keyword: keyword)
    }
}
