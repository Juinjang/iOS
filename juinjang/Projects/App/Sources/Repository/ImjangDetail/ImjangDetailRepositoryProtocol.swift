//
//  ImjangDetailRepositoryProtocol.swift
//  juinjang
//
//  Created by KimDongWoo on 4/11/25.
//

import RxSwift

protocol ImjangDetailRepositoryProtocol {
    func fetchInfo() -> Observable<ImjangDetailInfoModel>
    func fetchReport() -> Observable<ImjangDetailReportModel>
    func fetchCheckList() -> Observable<[ImjangDetailCheckListModel]>
    func fetchReview() -> Observable<ImjangDetailReviewModel>
}
