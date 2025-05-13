//
//  UserRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 4/27/25.
//

import RxSwift

final class UserRepository: UserRepositoryProtocol {
    private let userDefault: UserDefaultManager
    
    init(userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.userDefault = userDefault
    }
    
    func getUserNickname() -> Observable<String> {
        return .just(userDefault.nickname)
    }
}
