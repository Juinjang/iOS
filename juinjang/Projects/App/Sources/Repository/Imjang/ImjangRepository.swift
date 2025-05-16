//
//  ImjangRepository.swift
//  juinjang
//
//  Created by KimDongWoo on 5/14/25.
//

import Foundation
import RxSwift

final class ImjangRepository: ImjangRepositoryProtocol {
    private var networkManager: JuinjangAPIManager
    private var userDefault: UserDefaultManager
    
    init(networkManager: JuinjangAPIManager = JuinjangAPIManager.shared,
         userDefault: UserDefaultManager = UserDefaultManager.shared) {
        self.networkManager = networkManager
        self.userDefault = userDefault
    }
    
    func retrieveImjangDetail(noteID id: Int) -> Single<ImjangDetailInfoModel> {
        return ImjangAPI.getImjangDetail(id)
            .request(BaseResponse<ImjangDetailInfoModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveImjangDetailReport(noteID id: Int) -> Single<ImjangDetailReportModel> {
        return ImjangAPI.getImjangDetailReport(id)
            .request(BaseResponse<ImjangDetailReportModel>.self, networkManager)
            .map { try $0.unwrap() }
    }
    
    func retrieveImjangDetailCheckList(noteID id: Int) -> Single<ImjangDetailCheckListDTO> {
        return ImjangAPI.getImjangDetailChecklist(id)
            .request(BaseResponse<ImjangDetailCheckListDTO>.self, networkManager)
            .map { try $0.unwrap() }
    }
}
