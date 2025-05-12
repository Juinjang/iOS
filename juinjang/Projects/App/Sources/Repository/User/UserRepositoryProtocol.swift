//
//  UserRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/27/25.
//

import RxSwift

protocol UserRepositoryProtocol {
    func getUserNickname() -> Observable<String>
}
