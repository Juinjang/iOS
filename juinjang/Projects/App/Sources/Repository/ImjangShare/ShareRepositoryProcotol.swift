//
//  ImjangShareRepositoryProcotol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import RxSwift

protocol ShareRepositoryProcotol {
    func fetchShareSelectNote() ->  Observable<[ShareSelectModel]>
}
