//
//  ImjangShareRepositoryProcotol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/26/25.
//

import RxSwift

protocol ImjangShareRepositoryProcotol {
    func fetchShareSelectNote() ->  Observable<[ImjangShareSelectModel]>
}
