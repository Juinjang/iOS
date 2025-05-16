//
//  ImjangRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 5/14/25.
//

import RxSwift

protocol ImjangRepositoryProtocol {
    func retrieveImjangDetail(noteID id: Int) -> Single<ImjangDetailInfoModel>
    func retrieveImjangDetailReport(noteID id: Int) -> Single<ImjangDetailReportModel>
    func retrieveImjangDetailCheckList(noteID id: Int) -> Single<ImjangDetailCheckListDTO>
}
